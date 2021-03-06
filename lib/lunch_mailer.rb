# -*- coding: utf-8 -*-
class LunchMailer
  def initialize(orders)
    @orders = orders
  end

  def formatted_content
    list = @orders.map do |o|
      "- #{o.user}\t: #{o.dish}"
    end.join("\n")

    <<-CONTENT
From: McKI Team <#{ADMIN_EMAIL}>
To: Admin <#{LUNCH_ORDER_EMAIL}>
Content-type: text/plain; charset=UTF-8
Subject: McKI Đăng Ký Món Ăn Ngoài

Hi Admin,

Cho mình đăng ký món ăn ngoài hôm nay cho các thành viên sau:

#{list}

Cảm ơn,
McKI Team
    CONTENT
  end

  def send
    Net::SMTP.start(*SMTP_AUTH) do |smtp|
      smtp.send_message(formatted_content, ADMIN_EMAIL,
                        [LUNCH_ORDER_EMAIL, ADMIN_EMAIL])
    end
  end
end
