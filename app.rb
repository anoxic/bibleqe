require 'sinatra'
require 'haml'
require_relative 'bibleqe'

set :bind, '0.0.0.0'
set :port, 80

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
