class Installment < ActiveRecord::Base
  belongs_to :person
  belongs_to :purchase

  scope :for_pay_in_date, ->(date) {
    select("installments.p_day", "installments.person_id", "SUM(value) as total_value").includes(:person).group("p_day, person_id").where(p_day: date)    
  }

  scope :for_pay_in_date_with_person_id, ->(date, person_id) {
    where(p_day: date, person_id: person_id).includes(:person, :purchase)  
  }
end
