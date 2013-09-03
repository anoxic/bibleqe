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
  x = Shell.new(params[:q] + " :all", false)
  "<title>#{params[:q]}</title>" + x.out.gsub(/[\n\[\]]/, "\n"=>"<br>", "["=>"<i>", "]"=>"</i>")
end
