class Installment < ActiveRecord::Base
  belongs_to :person

  scope :for_pay_in_date, ->(date) {
    select("installments.p_day", "installments.person_id", "SUM(value) as total_value").includes(:person).group("p_day, person_id").where(p_day: date)    
  }
end
