class Person < ActiveRecord::Base
  has_many :installments
  has_many :installments_for_pay, -> { where "p_day >= ?", DateTime.now.utc}, class_name: "Installment"
  has_many :purchases, through: :installments
end
