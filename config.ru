require "sinatra/base"
require "sinatra/reloader"
require "grape"
require 'httparty'
require 'time_difference'
require_relative "server"
run Sinatra::Server


class API < Grape::API
  format :json
  get :album_status do
    response = HTTParty.get("https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=tool%20discography")
    @discography = response["query"]["pages"]["7014851"]["extract"]
    if @discography.include?("five studio albums" || "fifth album" || "5th album")
      { new_album: 'yes'}
    else
      start_time = Time.new(2006, 4, 28)
      end_time = Time.now
      @difference = TimeDifference.between(start_time, end_time).in_general
      { new_album: 'no',
        since_last: @difference}
    end
  end
end

class Server < Sinatra::Base

  get "/" do
    erb :index
  end
end



use Rack::Session::Cookie
run Rack::Cascade.new [API, Server]
