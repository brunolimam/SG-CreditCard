class Installment < ActiveRecord::Base
  belongs_to :person
  belongs_to :purchase

  scope :per_month, -> {
    all.includes(purchase: :credit_card).group_by {|installment| installment.p_day.strftime('%Y/%m') }.sort
  }  

  scope :per_credit_card, -> {
    all.includes(purchase: :credit_card).group_by {|installment| installment.purchase.credit_card}.sort
  }  

  scope :after_date, ->(date) {
    where("p_day >= ?", date).order(p_day: :asc)
  }

  scope :after_date_for_count, -> {
    select(:p_day).where("p_day >= ?", DateTime.now.utc).group(:p_day)
  }   

  scope :for_pay_in_date, ->(date) {
    select("installments.p_day", "installments.person_id", "installments.value", "installments.purchase_id").includes(:person, :purchase).where(p_day: date).order("purchases.purchased_in ASC")    
  }

  scope :for_pay_in_date_per_person, ->(date) {
    select("installments.p_day", "installments.person_id", "SUM(installments.value) as total_value").includes(:person).group("installments.p_day, installments.person_id").where(p_day: date).order("total_value desc")    
  }

  scope :for_pay_in_date_with_person_id, ->(date, person_id) {
    where(p_day: date, person_id: person_id).includes(:person, :purchase).order("purchases.purchased_in")
  }

  def paid?
    self.p_day<DateTime.now.utc ? true : false
  end

  def self.has_prev_for_person? cc, date,person_id
     cc.installments.where(p_day: date-1.month, person_id: person_id).size > 0 ? true : false
  end

  def self.has_next_for_person? cc, date,person_id
     cc.installments.where(p_day: date+1.month, person_id: person_id).size > 0 ? true : false
  end

  def self.has_next? cc, date
     cc.installments.where(p_day: date+1.month).size > 0 ? true : false
  end

  def self.has_prev? cc, date
     cc.installments.where(p_day: date-1.month).size > 0 ? true : false
  end

end
