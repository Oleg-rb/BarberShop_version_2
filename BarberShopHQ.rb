require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'

set :database, "sqlite3:barbershop.db"

class Client < ActiveRecord::Base
	validates :name, presence: true
	validates :phone, presence: true
	validates :datestamp, presence: true
	validates :color, presence: true
end

class Barber < ActiveRecord::Base
end

before do
	@barbers = Barber.order 'created_at DESC'
end

get '/' do
	erb :index
end

get '/about' do
	erb :about
end

get '/admin' do
	erb :admin
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end

post '/admin' do
	@login    = params[:login]
	@password = params[:password]
	@file     = params[:file]

	if @login == 'admin' && @password == 'secret' && @file == 'Посетители'
		@logfile = @file_users
		send_file './public/users.txt'
		erb :create
	elsif @login == 'admin' && @password == 'secret' && @file == 'Контакты'
		@logfile = @file_contacts
		send_file './public/contacts.txt'
		erb :create
	else
		@error ='Access denied'
		erb :admin
	end	
end

post '/contacts' do

	@email        = params[:email]
	@user_message = params[:user_message]

	hh = { :email        => 'Введите Ваш емайл',
		   :user_message => 'Введите Ваше сообщение' }

		@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

		if @error != ''
			return erb :contacts
		end

	@title = "Большое спасибо!"
	@message = "<h4>Ваше сообщение очень важно для нас!</h4>
	            <h4>Мы не передаём информацию третьим лицам!</h4>"

	file_contacts = File.open './public/contacts.txt', 'a'
	file_contacts.write "Users_email: #{@email},   Users_message: #{@user_message}\n"
	file_contacts.close

	erb :message
end

post '/visit' do

	c = Client.new params[:client]
	if c.save
		erb "<h2>Спасибо, Вы записались!</h2>"
	else
		erb "<h2>Ошибка</h2>"
	end
end
