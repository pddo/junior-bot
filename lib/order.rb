class Order < Sequel::Model

  def self.today
    where("created_at::DATE = '#{Date.today}'")
  end
  
  def self.add_today_request(user, dish)
    orders = today.where(user: user).all
    orders[1..-1].each(&:delete) if orders.count > 1
    order = orders.first || new(user: user)
    order.dish = dish
    order.save
  end

  def self.cancel_today_request(user)
    today.where(user: user).delete
  end

  def self.clear_today_requests
    today.delete
  end
end
