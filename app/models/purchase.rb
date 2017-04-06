class Purchase < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_many :installments
  has_many :installments_pending, -> { after_date_for_count }, class_name: 'Installment'

  has_many :people, -> { uniq }, through: :installments

  belongs_to :credit_card


  scope :find_purchaser, ->(search) {
    joins('INNER JOIN installments i on i.purchase_id = purchases.id').joins('INNER JOIN people pp on i.person_id = pp.id').where("pp.name ILIKE ?", "%"+search+"%").uniq
  }

  scope :purchases, ->(person_id) {
    joins('INNER JOIN installments i on i.purchase_id = purchases.id').where("i.person_id = ?", person_id).uniq
  }

  scope :pending, -> {
    where("p_day >= ?", DateTime.now.utc)
  }

  scope :purchases_pending, ->{
   joins('INNER JOIN installments i on i.purchase_id = purchases.id').where("p_day >= ?", DateTime.now.utc).uniq 
  }
  

  def paid?
    self.installments.last.p_day <= DateTime.now.utc ? true : false if self.installments.last.present?
  end    

  def create_installments(people)
    @people = Person.where(id: people.map{|x| x[:id]}).order(id: :asc)
    people = people.sort_by { |h| h[:id] }

    p_days = []
    p_days << next_day_of_date(self.purchased_in, Setting.closing_day)

    (self.quantity_installments-1).times do 
      p_days << p_days.last+1.month
    end

    @people.each_with_index do |person, index|
      self.quantity_installments.times do |i|
        Installment.create(person_id: person.id, purchase_id: self.id, number: i+1, value: people[index][:value].to_f/quantity_installments, p_day: p_days[i])
      end
    end
  end

  def value_of_person(person)
    self.installments.where(person_id: person.id).map(&:value).inject(:+)
  end

  def value_of_person_for_bill(person)
    self.installments.where(person_id: person.id).map(&:value).first
  end

  def value_ok person
   bill_value = self.value_of_person(person)/self.quantity_installments
   remaining = self.quantity_installments - self.installments_pending.size
   bill_value * remaining
  end

  def value_remaining person
   bill_value = self.value_of_person(person)/self.quantity_installments   
   bill_value * self.installments_pending.size
  end  

  def quantity_installments_ok
    self.quantity_installments - self.installments_pending.size
  end
  
  def quantity_installments_remaining
    self.installments_pending.size
  end  

  def value_total_remaining
   bill_value = self.value/self.quantity_installments   
   bill_value * self.installments_pending.size
  end 

  def payment
    "#{number_to_currency(value)} em #{quantity_installments}x  de #{number_to_currency(value/quantity_installments)}"
  end

  def payment_bills person
    bill_value = self.value_of_person(person)/self.quantity_installments  
    "#{quantity_installments} x #{number_to_currency(bill_value)}"
  end  

  private
    def next_day_of_date(date, close_bill_day)
      offset_day = close_bill_day-date.day

      date = date+1.month
      date = date+1.month if offset_day<=0
      
      DateTime.parse("#{date.year}/#{date.month}/#{Setting.payment_day}").utc
    end
end
