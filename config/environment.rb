require 'sinatra'
require 'httparty'
require 'json'
require 'sequel'
require 'dotenv'
require 'logger'

APP_ROOT = File.expand_path '../../', __FILE__

Dotenv.load

Sequel.extension :migration, :core_extensions
Sequel::Model.plugin :timestamps, :force => true, :update_on_create => true

DB = Sequel.connect(ENV['DATABASE_URL'])
#DB.logger = Logger.new($stdout) # for testing only
Sequel::Migrator.apply(DB, './migrations')

require './app'
Dir.glob(File.join(APP_ROOT, 'lib/*.rb')).each { |f| require f }
