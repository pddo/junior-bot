require File.expand_path '../../test_helper.rb', __FILE__

describe 'Lunch Order' do

  before(:all) do
    @user = 'tester'
  end

  let(:params) do
    {
      'token' => ENV['SLACK_TOKEN'],
      'channel_name' => 'general',
      'user_name' => @user,
      'text' => '#lunch menu',
      'trigger_word' => '#lunch'
    }
  end

  it 'should successfully return a greeting' do
    get '/'
    last_response.body.must_include 'Hello! Welcome to Junior Slackbot'
  end

  describe 'Out service time' do
    before(:all) do
      def Order.over_lunch_deadline?
        true
      end
    end

    it 'should not return today menu' do
      params['text'] = '#lunch menu'
      post '/gateway', params
      last_response.body.must_match(/Lunch order is out of service!/)
    end

    it 'should not order dish' do
      dish_idx = 0
      params['text'] = "#lunch order #{dish_idx + 1}"
      post '/gateway', params
      last_response.body.must_match(/Lunch order is out of service!/)
    end
  end

  describe 'In service time' do
    before(:all) do
      def Order.over_lunch_deadline?
        false
      end
    end

    it 'should return today menu' do
      params['text'] = '#lunch menu'
      post '/gateway', params
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

    it 'should cancel dish successfully' do
      dish_idx = 0
      dish = Dish.today_dishes[dish_idx]
      user = @user
      Order.add_today_request(user, dish)

      params['text'] = '#lunch cancel'
      post '/gateway', params
      last_response.body.must_match(/Canceled order of/)

      Order.today.where(user: params['user_name']).count.must_equal 0
    end

    it 'should clear dishes successfully' do
      Order.add_today_request(@user + '1', Dish.today_dishes[0])
      Order.add_today_request(@user + '2', Dish.today_dishes[1])

      params['text'] = '#lunch clear'
      post '/gateway', params
      last_response.body.must_match(/All today orders have been canceled!/)

      Order.today.count.must_equal 0
    end

    it 'should show help message' do
      params['text'] = '#lunch help'
      post '/gateway', params
      last_response.body.must_match(/Following are valid/)
    end

    it 'should send mail successfully' do
      dish_idx = 0
      dish = Dish.today_dishes[dish_idx]
      user = @user
      Order.add_today_request(user, dish)

      params['text'] = '#lunch send'
      post '/gateway', params
      last_response.ok?.must_equal true
      last_response.body.must_match(/Lunch requestes have been sent!/)
    end

    it 'should send mail successfully version 2' do
      dish_idx = 0
      dish = Dish.today_dishes[dish_idx]
      user = @user
      Order.add_today_request(user, dish)

      params['text'] = '#lunch send.'
      post '/gateway', params
      last_response.ok?.must_equal true
      last_response.body.must_match(/Lunch requestes have been sent!/)
    end
  end
end
