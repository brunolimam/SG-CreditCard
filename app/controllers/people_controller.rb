class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :installments]

  def index
    @search = Person.all.order(:name).includes(:installments, :installments_for_pay)
    @search = @search.search(params[:q])
    @people = @search.result

    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save       
        format.json { head :no_content }
        format.js 
      else        
        format.json { render json: @user.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def installments
    
  end  

  def edit
  end

  def update
    respond_to do |format|
      if @person.update(person_params)
        format.json { head :no_content }
        format.js
      else        
        format.json { render json: @person.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url}
      format.js      
      format.json { head :no_content }
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:name)
    end 
end
