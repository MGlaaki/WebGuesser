require 'sinatra'
require 'sinatra/reloader'

secretNumber = rand(101)

get '/' do
  erb :index, :locals => {:number => secretNumber}
end
