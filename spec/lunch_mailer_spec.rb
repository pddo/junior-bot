# -*- coding: utf-8 -*-
require File.expand_path '../../test_helper.rb', __FILE__

describe LunchMailer do
  it 'should send mail successfully' do
    not_test = true
    if not_test
      puts 'Only run when need to test mail engine. Shut down now!'
    else
      orders = [
        Order.new(user: 'Test User1', dish: 'hủ tiếu'),
        Order.new(user: 'Test User2', dish: 'bún mọc')
      ]
      proc { LunchMailer.new(orders).send }.must_be_silent
    end
  end
end
