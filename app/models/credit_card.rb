class CreditCard < ActiveRecord::Base
	has_many :purchases
	has_many :installments, through: :purchases
end
