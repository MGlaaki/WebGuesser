require 'sinatra'
require 'sinatra/reloader'

secretNumber = rand(101)

get '/' do
  "Secret number is " + secretNumber.to_s + "!"
end
