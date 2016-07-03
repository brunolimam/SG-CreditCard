class Installment < ActiveRecord::Base
  belongs_to :person
  belongs_to :purchase


  scope :per_month, -> {
    select(:p_day, "SUM(value) as total_value").group(:p_day).order(:p_day)
  }  

  scope :after_date, ->(date) {
    where("p_day >= ?", date)
  }

  scope :for_pay_in_date, ->(date) {
    select("installments.p_day", "installments.person_id", "SUM(value) as total_value").includes(:person).group("p_day, person_id").where(p_day: date).order("total_value desc")    
  }

  scope :for_pay_in_date_with_person_id, ->(date, person_id) {
    where(p_day: date, person_id: person_id).includes(:person, :purchase).order("purchases.purchased_in")
  }

  def self.has_next? date
     Installment.where(p_day: date+1.month).size > 0 ? true : false
  end

  def self.has_prev? date
     Installment.where(p_day: date-1.month).size > 0 ? true : false
  end

end
