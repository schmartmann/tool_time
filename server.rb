module Sinatra
  class Server < Sinatra::Base
    get "/" do
      erb :index
    end
  end
end