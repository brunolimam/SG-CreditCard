class InstallmentsController < ApplicationController
  def index
    @installments = Installment.all.includes(:person).order(:p_day)
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
