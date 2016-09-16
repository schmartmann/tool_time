require "sinatra/base"
require "sinatra/reloader"
require "grape"
require_relative "server"
run Sinatra::Server


class API < Grape::API
  get :album_status do
    { new_album: 'no' }
  end
end

class Server < Sinatra::Base
  get "/" do
    erb :index
  end
end

use Rack::Session::Cookie
run Rack::Cascade.new [API, Server]
