require File.expand_path '../../test_helper.rb', __FILE__

describe LunchMailer do
  it 'should send mail successfully' do
    orders = [
      Order.new(user: 'Test User1', dish: 'Something eatable'),
      Order.new(user: 'Test User2', dish: 'Something eatable'),
    ]

    proc { LunchMailer.new(orders).send }.must_be_silent
  end
end