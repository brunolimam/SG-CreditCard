class InstallmentsController < ApplicationController
  def index
    @installments = Installment.per_month
   end

  def bills
    @installments = Installment.per_month.after_date(DateTime.now.utc)
    render :index
  end

  def details_bills
    @installments = Installment.for_pay_in_date(params[:p_day]).load
    render :details
  end

  def details_bill_per_person
    @installments = Installment.for_pay_in_date_with_person_id(params[:p_day], params[:person_id]).load
  end
end
