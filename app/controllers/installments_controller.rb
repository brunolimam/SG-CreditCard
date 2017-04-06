class InstallmentsController < ApplicationController
  before_action :set_credit_card, only: [:details_bills, :details_bill_per_person]

  def index
    # @installments = CreditCard.last.installments.per_month
    if params[:after_date].present?
      @installments = Installment.after_date(params[:after_date]).per_month
      @installments_per_cc||= Installment.after_date(params[:after_date]).per_credit_card
    end

    @installments||= Installment.per_month
    @installments_per_cc||= Installment.per_credit_card
  end

  def details_bills
    @installments = @credit_card.installments.for_pay_in_date(params[:p_day]).load
    @installments = @credit_card.installments.for_pay_in_date_per_person(params[:p_day]).load if params[:per_person].present?

    render :details
  end

  def details_bill_per_person
    @installments = @credit_card.installments.for_pay_in_date_with_person_id(params[:p_day], params[:person_id]).load
  end

  private
  def set_credit_card
    @credit_card = CreditCard.find(params[:credit_card_id])
  end
end
