require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'logger'
require 'net/smtp'

APP_ROOT = File.expand_path '../../', __FILE__

Dotenv.load

Sequel.extension :migration, :core_extensions
Sequel::Model.plugin :timestamps, :force => true, :update_on_create => true

DB = Sequel.connect(ENV['DATABASE_URL'])
#DB.logger = Logger.new($stdout) # for testing only
Sequel::Migrator.apply(DB, './migrations')

# Mailer configurations
SMTP_AUTH = [
  'mail.elarion.com',
  587,
  'elarion.com',
  ENV['SMTP_USERNAME'],
  ENV['SMTP_PASSWORD']
]

ADMIN_EMAIL = ENV['SMTP_USERNAME']
LUNCH_ORDER_EMAIL = ENV['LUNCH_ORDER_EMAIL']
LUNCH_ORDER_DEADLINE = '10:30 +0700'

AUTH_TOKEN = ENV['SLACK_TOKEN']

require './app'
Dir.glob(File.join(APP_ROOT, 'lib/*.rb')).each { |f| require f }
