class Purchase < ActiveRecord::Base
  has_many :installments
  has_many :people, through: :installments

  def create_installments(people)
    @people = Person.where(id: people.map{|x| x[:id]}).order(id: :asc)
    people = people.sort_by { |h| h[:id] }

    p_days = []
    p_days << next_day_of_date(self.purchased_in, configatron.close_day_credit_card)

    (self.quantity_installments-1).times do 
      p_days << p_days.last+1.month
    end

    @people.each_with_index do |person, index|
      self.quantity_installments.times do |i|
        Installment.create(person_id: person.id, purchase_id: self.id, number: i+1, value: people[index][:value].to_f/quantity_installments, p_day: p_days[i])
      end
    end
  end

  private
    def next_day_of_date(date, close_bill_day)
      offset_day = close_bill_day-date.day

      date = date+1.month
      date = date+1.month if offset_day<=0
      
      DateTime.parse("#{date.year}/#{date.month}/#{configatron.payment_day_credit_card}").utc
    end
end
