class FixPDayFromInstallments < ActiveRecord::Migration
  def change
    FixPDayFromInstallments.up
  end

  def self.up
    Installment.all.each do |installment|
      date = installment.p_day
      date = (date+1.month).change({ day: configatron.payment_day_credit_card })

      installment.update(p_day: date)
    end
  end
end
