require "sinatra/base"
require "sinatra/reloader"
require_relative "server"
run Sinatra::Server

	@response = HTTParty.get('http://itunes.com/api/')
	puts response.body, response.code,
	response.message,
	response.headers.inspect
class TunesApi 
	def index
			@response 
			 redirect_to "/tool"

		end

		def show
			@response = Train.find_by(id: params[:id])
			redirect_to "/trains/<%=@train%>"
		end
	
end
