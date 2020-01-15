require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
end

class Barber < ActiveRecord::Base
end

get '/' do
	erb "Hello! <a href=\"https://github.com/Oleg-rb/Template/\">Original</a> pattern has been modified for <a href=\"https://github.com/Oleg-rb/Template/\">Template</a>"			
end
