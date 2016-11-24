class InstallmentsController < ApplicationController
  before_action :get_fixed_installments

  def index
    @installments = Installment.not_fixed.per_month
   end

  def bills
    @installments = Installment.not_fixed.per_month.after_date(DateTime.now.utc)
    render :index
  end

  def details_bills
    @installments = Installment.for_pay_in_date(params[:p_day]).load

    if params[:per_person].present?
      @installments = Installment.for_pay_in_date_per_person(params[:p_day]).load
    end
    render :details
  end

  def details_bill_per_person
    @installments = Installment.for_pay_in_date_with_person_id(params[:p_day], params[:person_id]).load
  end

  private 
  def get_fixed_installments
    @fixed_installments = Installment.fixed
  end
end
