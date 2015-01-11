require 'erb'
require 'json' # wickedpdfの後に呼ぶ

def filename
    t = Time.now.instance_eval { '%s.%03d' % [strftime('%Y/%m/%d %H:%M:%S'), (usec / 1000.0).round] }
    Digest::SHA256.hexdigest t
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
    name = 'public/files/print/pdf/'+filename+'.pdf'
    File.write(name, pdf) # 中間ファイル

    name
end

json = File.read("tmp/sample.json")
action_list = JSON.parse(json)

# make html
html = File.read('public/files/print/template/print.html')
erb = ERB.new(html)
bind_html = erb.result(binding)
File.write('public/files/print/html/hoge.html', bind_html) # 中間ファイル

write_pdf(bind_html)
