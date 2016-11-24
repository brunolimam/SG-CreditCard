class Installment < ActiveRecord::Base
  belongs_to :person
  belongs_to :purchase

  scope :fixed, -> {
    joins(:purchase).where(purchases: {fixed: true})
  }

  scope :not_fixed, -> {
    joins(:purchase).where(purchases: {fixed: [false, nil]})
  }

  scope :per_month, -> {
    select(:p_day, "SUM(installments.value) as total_value").group(:p_day).order(:p_day)
  }  

  scope :after_date, ->(date) {
    where("p_day >= ? OR p_day IS NULL", date)
  }

  scope :after_date_for_count, -> {
    select(:p_day).where("p_day >= ?", DateTime.now.utc).group(:p_day)
  }   

  scope :for_pay_in_date, ->(date) {
    select("installments.p_day", "installments.person_id", "installments.value", "installments.purchase_id").includes(:person, :purchase).where(p_day: [date, nil]).order("purchases.purchased_in ASC")    
  }

  scope :for_pay_in_date_per_person, ->(date) {
    select("installments.person_id", "SUM(installments.value) as total_value").includes(:person).group("person_id").where(p_day: [date, nil]).order("total_value desc")    
  }

  scope :for_pay_in_date_with_person_id, ->(date, person_id) {
    where(p_day: [date, nil], person_id: person_id).includes(:person, :purchase).order("purchases.purchased_in")
  }

  def paid?
    return false if p_day.nil?
    self.p_day<DateTime.now.utc ? true : false
  end

  def self.has_prev_for_person? date,person_id
     Installment.where(p_day: date-1.month, person_id: person_id).size > 0 ? true : false
  end

  def self.has_next_for_person? date,person_id
     Installment.where(p_day: date+1.month, person_id: person_id).size > 0 ? true : false
  end

  def self.has_next? date
     Installment.where(p_day: date+1.month).size > 0 ? true : false
  end

  def self.has_prev? date
     Installment.where(p_day: date-1.month).size > 0 ? true : false
  end

end
