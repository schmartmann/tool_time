require "sinatra"
require "grape"

  module Sinatra

  class API < Grape::API
    get :hello do
      { hello: 'friends' }
    end
  end

  class Server < Sinatra::Base
    get "/" do
      erb :index
    end
  end
end
