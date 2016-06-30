class InstallmentsController < ApplicationController
  def index
    @installments = Installment.per_month
   end

  def for_pay
    @installments = Installment.per_month.after_date(DateTime.now.utc)
    @installments = Installment.for_pay_in_date(params[:p_day]).load if params[:p_day].present?
    @installments = Installment.for_pay_in_date_with_person_id(params[:p_day], params[:person_id]).load if params[:p_day].present? && params[:person_id].present?
  
    render :index
  end
end
