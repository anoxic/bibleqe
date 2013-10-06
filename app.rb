require 'sinatra'
require 'haml'
require 'sass'
require_relative 'bibleqe'

set :bind, '0.0.0.0'

if ARGV[0].to_i > 1
  set :port, ARGV[0]
else
  set :port, 9001
end

get '/' do
  haml :index
end

get '/search' do
  redirect '/' if params[:q].nil?

  parser = Parse.new(params[:q])
  args = parser.args
  options = parser.options

  text = options[:text] ? options[:text] : :kjv

  # Get results          
  search = Search.new(text)
  result = search.query(args)

  haml :result, locals: {result: result, list: options[:list] ? true : false}
end

get '/robots.txt' do
  content_type 'text/plain'
  "User-agent: *\nAllow: *"
end

get '/googlefb83095fe398976d.html' do
  'google-site-verification: googlefb83095fe398976d.html'
end
