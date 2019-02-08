#!/usr/local/bin/ruby

require 'rubygems'
require 'rack'
require 'haml'
require 'sass'
require_relative 'bibleqe'

#fastcgi_log = File.open("fastcgi.log", "a")
#STDOUT.reopen fastcgi_log
#STDERR.reopen fastcgi_log
#STDOUT.sync = true

module Rack
  class Request
    def path_info
      @env["REDIRECT_URL"].to_s
    end
    def path_info=(s)
      @env["REDIRECT_URL"] = s.to_s
    end
  end
end

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
  map '/robots.txt' do
    run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ["User-agent: *\nAllow: *"]] }
  end
  map '/googlefb83095fe398976d.html' do
    ok 'google-site-verification: googlefb83095fe398976d.html'
  end
end

Rack::Handler::FastCGI.run(builder, Port: '9001')
