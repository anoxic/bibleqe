require 'sinatra'
require_relative 'bibleqe'

set :bind, '0.0.0.0'
set :port, 80

get '/' do
  '<title>Bible Query Engine</title>
  Search the Bible: <form action=/search><input name=q></form>
  <pre>
Arguments not starting in : are used as search terms (in an AND search)

&lt;term&gt;|&lt;term&gt; executes an OR search

/&lt;regex&gt;/ for a regular expression search

:list list references

:text &lt;version&gt; Change text  (by version abbreviation)
  '
end

get '/search' do
  redirect '/' if params[:q].nil?
  x = Shell.new(params[:q] + " :all", false)
  "<title>#{params[:q]}</title>" + x.out.gsub(/[\n\[\]]/, "\n"=>"<br>", "["=>"<i>", "]"=>"</i>")
end
