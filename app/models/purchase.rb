class Purchase < ActiveRecord::Base
  has_many :installments

  def create_installments(people)
    @people = Person.where(id: people.map{|x| x[:id]})

    p_days = []
    p_days << next_day_of_date(self.purchased_in, configatron.close_day_credit_card)

    (self.quantity_installments-1).times do 
      p_days << p_days.last+1.month
    end

    @people.each_with_index do |person, index|
      self.quantity_installments.times do |i|
        Installment.create(person_id: person.id, purchase_id: self.id, value: people[index][:value].to_f/quantity_installments, p_day: p_days[i])
      end
    end
  end

  private
    def next_day_of_date(date, number)
      offset_day = number-date.day

      if offset_day<0
        date = (date+1.month).beginning_of_month
      end

      DateTime.parse("#{date.year}/#{date.month}/#{configatron.close_day_credit_card}").utc
    end
end
