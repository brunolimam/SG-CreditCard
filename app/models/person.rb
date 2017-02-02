class Person < ActiveRecord::Base
  has_many :installments, -> { order(:p_day) }
  has_many :installments_for_pay, -> { where "p_day >= ?", DateTime.now.utc}, class_name: "Installment"
  has_many :purchases, through: :installments


  def purchases_values
    self.installments.group_by_month(:p_day, format: "%b/%y").sum(:value)
  end


  def next_purchases_values
    self.installments.where("p_day >= ?", DateTime.now.utc).group_by_month(:p_day, format: "%b/%y").sum(:value)
  end  

  def value_remaining
  	self.installments.where("p_day >= ?", DateTime.now.utc).sum(:value)
  end

  def purchases_total
    self.installments.sum(:value)
  end  

end
