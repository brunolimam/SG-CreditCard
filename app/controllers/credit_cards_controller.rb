class CreditCardsController < ApplicationController
  before_action :set_credit_card, only: [:show, :edit, :update]

  def index
    @credit_cards = CreditCard.all
  end

  def show
  end

  def new
    @credit_card = CreditCard.new
  end

  def edit
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)

    respond_to do |format|
      if @credit_card.save       
        format.json { head :no_content }
        format.js 
      else        
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @credit_card.update(credit_card_params)
        format.json { head :no_content }
        format.js
      else
        format.json { render json: @credit_card.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit_card
      @credit_card = CreditCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_card_params
      params.require(:credit_card).permit(:display_number, :limit, :close_day, :p_day, :financial)
    end
end
