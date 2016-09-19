require "sinatra/base"
require "sinatra/reloader"
require "redis-sinatra"
require "whenever"
require "grape"
require 'httparty'
require "byebug"
require 'time_difference'
require 'twilio-ruby'
require_relative "server"

run Sinatra::Server
configure do
  REDISTOGO_URL = "redis://localhost:6379/"
  uri = URI.parse(REDISTOGO_URL)
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  byebug
  Thread.new {
  # Thread #2 runs this code
  every 1.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
    puts ('get NEW TOOL ALBUM STATUS')
    # runner "MyModel.some_process"
    # rake "my:rake:task"
    # command "/usr/bin/my_great_command"
  end
  }



end


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

  get '/testPost' do
    REDIS.set("isAlbumNew", "No")
  end

  get '/testGet' do
    puts 'OUR THREADS!'
    Thread.list.select {|thread| thread.status == "run"}.count
    REDIS.get("isAlbumNew")
  end

end

class Tool_time < Sinatra::Base
  register Sinatra::Cache
  get '/' do
    settings.cache.fetch('greet') { 'Hello, World!' }
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
