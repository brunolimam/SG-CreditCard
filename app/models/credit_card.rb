class CreditCard < ActiveRecord::Base
	has_many :purchases, dependent: :destroy
	has_many :installments, through: :purchases, dependent: :destroy
end
