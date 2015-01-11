class Application < Sinatra::Base
  configure do
    set :app_file, File.join(File.dirname(__FILE__), 'application.rb')
    set :public_folder,   File.join(File.dirname(__FILE__), '..', 'public')
    set :views,    File.join(File.dirname(__FILE__) , '..', 'views')
  end

  configure :production do
    register Sinatra::Reloader
  end

  configure :development do
    register Sinatra::Reloader
  end

  configure :test do

  end
end
