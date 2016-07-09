class Purchase < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  has_many :installments
  has_many :people, through: :installments


  scope :find_purchaser, ->(search) {
    joins('INNER JOIN installments i on i.purchase_id = purchases.id').joins('INNER JOIN people pp on i.person_id = pp.id').where("pp.name ILIKE ?", "%"+search+"%").uniq
  }

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

  def payment
    "#{number_to_currency(value)} em #{quantity_installments}x  de #{number_to_currency(value/quantity_installments)}"
  end

  private
    def next_day_of_date(date, close_bill_day)
      offset_day = close_bill_day-date.day

      date = date+1.month
      date = date+1.month if offset_day<=0
      
      DateTime.parse("#{date.year}/#{date.month}/#{Setting.payment_day}").utc
    end
end
