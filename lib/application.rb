require 'rubygems'
require 'sinatra/base'
require "sinatra/reloader"
require 'digest/sha2'
require 'erb'
require 'json' # wickedpdfの後に呼ぶ
require File.join(File.dirname(__FILE__), 'configuration.rb')

class Application < Sinatra::Base
  # 共通メソッドはhelpersに書く
  # http://somethingpg.hatenablog.com/entry/2014/02/02/093844
  helpers do
    def filename
      t = Time.now.instance_eval { '%s.%03d' % [strftime('%Y/%m/%d %H:%M:%S'), (usec / 1000.0).round] }
      Digest::SHA256.hexdigest t
    end

    def create_action
      h = {
        "actions" => [],
        "sumLevel" => ""
      }
      h
    end

    # 1. 要素を30個に変換
    # 2. 要素を縦に並べる
    def remap_action_list(action_list)
      for i in 1..(30 - action_list.size)
        action_list << create_action
      end

      a = action_list.slice(0..9)
      b = action_list.slice(10..19)
      c = action_list.slice(20..29)

      t = a.zip(b).zip(c).flatten
    end

    def write_pdf(bind_html)
      require 'wicked_pdf' # 外部で読むと上手く行かない

      # make pdf
      WickedPdf.config = { :exe_path => '/usr/local/bin/wkhtmltopdf' }
      wp = WickedPdf.new
      pdf = wp.pdf_from_string( bind_html,
                               :margin => {:top => 0, # default 10 (mm)
                                           :bottom => 0,
                                           :left   => 0,
                                           :right  => 0})

      # sinatraのルーティングに合わせる
      name = '/files/print/pdf/'+filename+'.pdf'
      File.write("public"+name, pdf) # 中間ファイル

      name
    end
  end

  get '/?' do
    erb :index
  end

  post '/pdf', provides: :json do
    params = JSON.parse request.body.read
    # p params.to_s 

    # validate
    # ...
    action_list = params
    # 要素を縦に並べる
    action_list = remap_action_list(action_list)

    # make html
    html = File.read('public/files/print/template/print.html')
    erb = ERB.new(html)
    bind_html = erb.result(binding)
    File.write('public/files/print/html/hoge.html', bind_html) # 中間ファイル

    name = write_pdf(bind_html)

    content_type :json, :charset => "utf-8"
    res = {
      link:  name # ファイルのアクセス先を返す
    }
    res.to_json
  end

  post "/a" do
    b = {
      a: "b"
    }
    content_type :json, :charset => "utf-8"
    b.to_json
  end
end
