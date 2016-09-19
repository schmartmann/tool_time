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

  class Tool_time < Sinatra::Base
    # register Sinatra::Cache

    get '/hi' do
      # settings.cache.fetch('greet') { 'Hello, World!' }
    end
  end

end
