class InstallmentsController < ApplicationController
  def index
    @installments = Installment.select(:p_day, "SUM(value) as total_value").group(:p_day).order(:p_day)
    @installments = Installment.for_pay_in_date(params[:p_day]) if params[:p_day].present?
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end
end
