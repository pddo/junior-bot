require File.expand_path '../../test_helper.rb', __FILE__

describe 'Junior Bot' do

  let(:params) do
    {
      "token"=>ENV['SLACK_TOKEN'],
      "team_id"=>"T02K8KA7N",
      "team_domain"=>"msss",
      "service_id"=>"18141234355",
      "channel_id"=>"C02K8KA7Y",
      "channel_name"=>"general",
      "timestamp"=>"1452788559.000002",
      "user_id"=>"U02K92U3E",
      "user_name"=>"phucdd",
      "text"=>"#lunch menu",
      "trigger_word"=>"#lunch"
    }
  end

  it 'should successfully return a greeting' do
    get '/'
    last_response.body.must_include 'Hello! Welcome to Junior Slackbot'
  end

  it 'should return today menu' do
    params['text'] = '#lunch menu'
    post '/gateway', params
    puts last_response.body
    last_response.body.must_match(/Today menu:/)
  end

  it 'should order dish successfully' do
    dish_idx = 0
    params['text'] = "#lunch order #{dish_idx + 1}"
    post '/gateway', params
    last_response.body.must_match(/Noted:/)
    Order.today.where(user: params['user_name']).count.must_equal 1
    order = Order.today.where(user: params['user_name']).first
    order.dish.must_equal Dish.today_dishes[dish_idx]
  end
end
