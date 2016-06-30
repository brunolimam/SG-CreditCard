class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]
  autocomplete :person, :name, :full => true
  autocomplete :purchase, :place_name, :full => true, :uniq => true

  def index
    @purchases = Purchase.all.order(purchased_in: :desc)
  end

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @people = params[:people]

    respond_to do |format|
      if @purchase.save
        @purchase.create_installments(@people)
        format.json { head :no_content }
        format.js 
      else        
        format.json { render json: @purchase.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.json { head :no_content }
        format.js
      else        
        format.json { render json: @purchase.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase.destroy
    @purchase.installments.destroy_all
    respond_to do |format|
      format.html { redirect_to purchases_url}
      format.js      
      format.json { head :no_content }
    end
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:purchased_in, :quantity_installments, :place_name, :value)
    end 
end
