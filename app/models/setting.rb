class Setting < ActiveRecord::Base

  def self.payment_day
    Setting.find_by_parameter("paymentday").value.to_i
  end

  def self.closing_day
    Setting.find_by_parameter("closingday").value.to_i
  end
  
  def self.limit_card
    Setting.find_by_parameter("limitcard").value.to_i
  end

end
