require 'sinatra'
require 'httparty'
require 'json'

DAILY_MENU = YAML.load_file('config/daily_menu.yml')

post '/gateway' do
  puts 'PhucDDDDDDD'
  p params
  #return if params[:token] != ENV['SLACK_TOKEN']
  message = params[:text].gsub(params[:trigger_word], '').strip
  user = params['user_name']

  case message
  when 'menu'
    show_today_menu
    #respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
  when /^order \d+$/
    m = message.match(/^order (\d+)/)
    order(user, m[1])
  when 'cancel'
    cancel(user)
  when 'send request'
    send_request
  when 'clear'
    clear_orders
  else
    show_help
  end
end

get '/' do
  'Hello! Welcome to Junior Slackbot'
end

def show_today_menu
  week_day = Time.now.strftime('%A')
  dishes = DAILY_MENU[week_day].each_with_index.map do |dish, idx|
    "#{idx + 1}. #{dish}"
  end
  respond_message(dishes.join("\n"))
end

def respond_message(message)
  content_type :json
  { text: message }.to_json
end
