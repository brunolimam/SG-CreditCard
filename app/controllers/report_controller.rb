class ReportController < ApplicationController
  def purchases
  end

  def purchases_by_month
  end

  def purchases_by_person
  end

  def purchases_graphics
  	@purchases_by_month = Installment.group_by_month(:p_day, format: "%b/%y").sum(:value)
  end
end
