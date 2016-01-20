post '/gateway' do
  if params[:token] != AUTH_TOKEN
    return respond_message('You are not authorized!')
  end

  @trigger_word = params[:trigger_word]
  @message = params[:text].gsub(@trigger_word, '').strip.downcase
  @user = params['user_name']

  if Order.over_lunch_deadline?
    respond_message('Lunch order is out of service, please comeback tomorrow!')
  else
    do_lunch_actions
  end
end

get '/' do
  'Hello! Welcome to Junior Slackbot'
end

def do_lunch_actions
  case @message
  when /^menu(\.)?$/
    show_today_menu
  when /^order \d+$/
    m = @message.match(/^order (\d+)/)
    order(m[1])
  when 'cancel'
    cancel_orders
  when /^send(\.)?$/
    send_orders
  when 'clear'
    clear_orders
  else
    show_help
  end
end

def show_today_menu
  fdishes = Dish.today_dishes.each_with_index.map do |dish, idx|
    "#{idx + 1}. #{dish}"
  end

  if fdishes.empty?
    msg = 'No menu for ordering today, please comeback tomorrow! :P'
  else
    msg = "Today menu:\n" +
          fdishes.join("\n") +
          "\nOrder dish by command: `#{@trigger_word} order <menu #>`"
  end

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

def cancel_orders
  Order.cancel_today_request(@user)
  respond_message "Canceled order of @#{@user}"
end

def send_orders
  orders = Order.today_requests
  if orders.count.zero?
    msg = 'No request today!'
  else
    mailer = LunchMailer.new(orders)
    mailer.send
    msg = mailer.formatted_content +
          "\n Lunch orders have been sent!"

    Order.clear_today_requests
  end
  respond_message(msg)
end

def clear_orders
  Order.clear_today_requests
  respond_message('All today orders have been canceled!')
end

def show_help
  respond_message "Following are valid #{@trigger_word} commands :" \
    "\n- `#{@trigger_word} menu`: show today menu" \
    "\n- `#{@trigger_word} order <number>`: order dish at number in menu list" \
    "\n- `#{@trigger_word} cancel`: cancel order that you made today" \
    "\n- `#{@trigger_word} clear`: cancel all today orders (Please do not call it for fun!!! ^^!)" \
    "\n- `#{@trigger_word} send`: send order email (It's been scheduled, please do not call it)" \
    "\n **NOTE**: these commands are only available on public channels"
end

def respond_message(msg)
  content_type :json
  { text: msg }.to_json
end
