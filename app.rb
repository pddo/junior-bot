post '/gateway' do
  return if params[:token] != ENV['SLACK_TOKEN']

  @trigger_word = params[:trigger_word]
  message = params[:text].gsub(@trigger_word, '').strip
  @user = params['user_name']

  case message
  when 'menu'
    show_today_menu
  when /^order \d+$/
    m = message.match(/^order (\d+)/)
    order(m[1])
  when 'cancel'
    cancel
  when 'send'
    send
  when 'clear'
    clear
  else
    show_help
  end
end

get '/' do
  'Hello! Welcome to Junior Slackbot'
end

def show_today_menu
  fdishes = Dish.today_dishes.each_with_index.map do |dish, idx|
    "#{idx + 1}. #{dish}"
  end

  msg = "Today menu:\n" +
    fdishes.join("\n") +
    "\nOrder meal by command: `#{@trigger_word} order <menu #>`"

  respond_message(msg)
end

def order(dish_num)
  dish = Dish.today_dishes[dish_num.to_i - 1]
  if dish
    Order.add_today_request(@user, dish)
    msg = "Noted: '#{dish}' for @#{@user}"
  else
    msg = "Sorry, no dish for ##{dish_num}"
  end

  respond_message(msg)
end

def cancel
  #Order.cancel_today_request(@user)
end

# def send
#   #mail(Order.today_requests)
# end

def clear
  #Order.clear_today_requests
end

def respond_message(message)
  content_type :json
  { text: message }.to_json
end
