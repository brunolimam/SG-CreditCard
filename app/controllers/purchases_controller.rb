class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy, :details]
  before_action :prepare_purchases,:totalize_quantity,:totalize_values, only: [:index]
  autocomplete :person, :name, :full => true
  autocomplete :purchase, :place_name, :full => true, :uniq => true

  def index
    @purchases = @purchases.includes(:installments).paginate(:page => params[:page], :per_page => 20)
  end

  def details     
  end

  def simulate
  end

  def simulate_with_value
    @people = Person.find(params[:person_id])
  end  

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        @purchase.create_installments(params[:people])
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
        @purchase.installments.destroy_all
        @purchase.create_installments(params[:people])

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
    
    def check_if_true(item)
      if(item == 'true' or item == true or item == 1 or item == '1')
        return true
      else
        return false
      end
    end
    
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end
    def get_all_ok      
      all_ok = []
      Purchase.all.each do |purchase|
        if purchase.installments.last.p_day <= DateTime.now.utc
          all_ok << purchase
        end
      end
      return all_ok
    end

    def prepare_purchases
      type_search = params[:type_search]
      search = params[:search]
      @search = Purchase.all.order(purchased_in: :desc)
      @search = @search.purchases_pending if check_if_true(params[:remaining])
      @search = @search.where('purchases.id in (?)',get_all_ok) if check_if_true(params[:ok])
      @search = @search.find_purchaser(search) if type_search == 'name'
      @search = @search.where(type_search+" ILIKE ?", "%"+search+"%") if type_search.present? and type_search != 'name'      
      @search = @search.search(params[:q])
      @purchases = @search.result
    end

    def totalize_quantity
      @all = Purchase.count
      @remaining = Purchase.purchases_pending.size
      @ok = @all-@remaining

      @all_for_search = @purchases.size
      @remaining_for_search = @purchases.purchases_pending.size
      @ok_for_search = @all_for_search-@remaining_for_search
    end

    # def calc_value_remaining remaining
    #   total = 0      
    #   remaining.each do |p|
    #     total = total+p.value_total_remaining
    #   end
    #   total
    # end


    def totalize_values
      @value = Purchase.all
      @value_remaining = Purchase.purchases_pending.map(&:value_total_remaining).inject(:+)      
      @value_for_search = @purchases
      @value_remaining_for_search = @purchases.purchases_pending.map(&:value_total_remaining).inject(:+)     
    end    

    def purchase_params
      params.require(:purchase).permit(:purchased_in, :quantity_installments, :place_name, :value, :describe)
    end 
end
