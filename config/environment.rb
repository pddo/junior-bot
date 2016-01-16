# require 'sinatra'
# require 'httparty'
# require 'json'
# require 'sequel'
# require 'dotenv'
# require 'logger'
# require 'pony'
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = File.expand_path '../../', __FILE__

Dotenv.load

Sequel.extension :migration, :core_extensions
Sequel::Model.plugin :timestamps, :force => true, :update_on_create => true

DB = Sequel.connect(ENV['DATABASE_URL'])
#DB.logger = Logger.new($stdout) # for testing only
Sequel::Migrator.apply(DB, './migrations')

# Mailer configurations
Pony.options = {
  :subject => "Some Subject",
  :body => "This is the body.",
  :via => :smtp,
  :via_options => {
    :address              => 'mail.elarion.com',#'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => 'phucdd@elarion.com',
    :password             => ENV["SMTP_PASSWORD"],
    :authentication       => :plain # :plain, :login, :cram_md5, no auth by default
    #:domain               => "localhost.localdomain"
  }
}

require './app'
Dir.glob(File.join(APP_ROOT, 'lib/*.rb')).each { |f| require f }
