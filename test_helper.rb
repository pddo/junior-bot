ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'minitest/stub_any_instance'
require 'rack/test'
require 'pry'

require File.expand_path '../config/environment.rb', __FILE__
include Rack::Test::Methods

def app
  Sinatra::Application
end
