require 'rubygems'
require 'rack'
require 'haml'
require 'sass'
require_relative 'bibleqe'

#fastcgi_log = File.open("fastcgi.log", "a")
#STDOUT.reopen fastcgi_log
#STDERR.reopen fastcgi_log
#STDOUT.sync = true

def ok(body)
  use Rack::Lint
  run lambda { |env| [200, {'Content-Type' => 'text/html'}, [body]] }
end

def haml(view, bindings = {})
  name = "./views/#{view}.haml"
  unless File.exists? name
    return "E: Can't find #{view}.haml" 
  end
  file = File.read(name)
  engine = Haml::Engine.new(file)
  engine.render Object.new, bindings
end

def sass(view)
  name = "./views/#{view}.sass"
  unless File.exists? name
    return "E: Can't find #{view}.sass" 
  end
  file = File.read(name)
  engine = Sass::Engine.new(file)
  engine.render
end

builder = Rack::Builder.new do
  map '/' do
    ok haml :index
  end
  map '/usage' do
    ok haml :usage
  end
  map '/search' do
    run lambda { |env|
      headers = {'Content-Type' => 'text/html'}
      params = Rack::Utils.default_query_parser.parse_nested_query(env["QUERY_STRING"])
      params["q"] ||= ""

      parser = Parse.new(params["q"])
      args = parser.args
      options = parser.options

      text = options[:text] ? options[:text] : :kjv

      search = Search.new(text)
      result = search.query(args)

      body = haml :result, {params: params, result: result, list: options[:list] ? true : false}

      [200, headers, [body]]
    }
  end
  map '/robots.txt' do
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ["User-agent: *\nAllow: *"]] }
  end
  map '/googlefb83095fe398976d.html' do
    ok 'google-site-verification: googlefb83095fe398976d.html'
  end
end

Rack::Handler::FastCGI.run(builder, Port: '9001')
