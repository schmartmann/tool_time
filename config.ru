require "sinatra/base"
require "sinatra/reloader"
require "grape"
require 'httparty'
require 'time_difference'
require 'twilio-ruby'
require_relative "server"

run Sinatra::Server

class API < Grape::API
  format :json

  helpers do
    def get_album_status
      response = HTTParty.get("https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exlimit=max&explaintext&exintro&titles=tool%20discography")
      @discography = response["query"]["pages"]["7014851"]["extract"]
    end
  end


  get :album_status do
    get_album_status
    # if @discography.include?("five studio albums" || "fifth album" || "5th album")
    if @discography.include?("four studio albums")
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

  post "/" do
    if params
      account_sid = ENV["TWILIO_ACCOUNT_SID"]
      auth_token = ENV["TWILIO_AUTH_TOKEN"]
      @client = Twilio::REST::Client.new account_sid, auth_token
      @sender ="+15856435230"
      @tools = [
        {number: "+15853092274",
        name: "Stefan"}
      ]
      @message = @client.messages.create({
        from: @sender,
        to: @tools[0][:number],
        body: 'The new Tool album has finally been released! Guess what time it is!',
        media_url: 'https://sitcomnation.files.wordpress.com/2012/11/tool-time.jpeg'
      })
      end
    erb :index
  end
end



use Rack::Session::Cookie
run Rack::Cascade.new [API, Server]
