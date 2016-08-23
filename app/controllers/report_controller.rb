class ReportController < ApplicationController
	before_action :set_purchases, only: [:purchases_person_by_person,:purchases_by_person,:purchases]
  before_action :set_purchases_values, only: [:purchases_values_by_person_in_months]

  def prepare
  end

  def orientation ret    
    return ret ? "Landscape" : "Portrait"
  end

  def purchases
    @total = @purchases.map(&:value).inject(:+)
    @title = "Relatório de Compras"
    @orientation = orientation(true)
    set_pdf_data 'pdf/purchases',@purchases,@title,@orientation
  end

  def purchases_person_by_person    
    @title = "Relatório de Compras por Pessoa" 
    @orientation = orientation(false)
    set_pdf_data 'pdf/purchases_person_by_person',@purchases_by_person,@title,@orientation
  end

  def purchases_by_month     
  end

  def purchases_values_by_person_in_months   
    @total = @person.installments.map(&:value).inject(:+)     
    @title = "Relatório Valores Faturas por Pessoa"  
    @orientation = orientation(false)
    set_pdf_data 'pdf/purchases_values_by_person_in_months',@purchases_values,@title,@orientation
  end  

  def purchases_values_for_persons_in_months   
    @title = "Relatório Valores Faturas por Pessoas"  
    @orientation = orientation(false)
    set_pdf_data 'pdf/purchases_values_for_persons_in_months',@people = Person.order(:name),@title,@orientation
  end   

  def purchases_by_person      
    set_person    
    @title = "Relatório Compras por Pessoa"  
    @orientation = orientation(true)
    set_pdf_data 'pdf/purchases_by_person',@purchases_by_person,@title,@orientation 
  end

  def purchases_graphics
  	@purchases_by_month = Installment.group_by_month(:p_day, format: "%b/%y").sum(:value)
  end


  def set_pdf_data action,data,report_name,orientation
     html = render_to_string(:action => action, :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => report_name,:orientation => orientation)     
     kit.stylesheets << "#{Rails.root}/vendor/assets/bootstrap.css"     
     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => data

  end


  private 
  def set_purchases_values
    set_person
    @purchases_values = @person.installments.group_by_month(:p_day, format: "%b/%y").sum(:value)    
  end    

  def set_purchases
    sort = params[:sort]
    order = params[:order]      	
    @purchases = Purchase.order(sort+' '+order).all
    @purchases_by_person = @purchases.purchases(params[:person_id])
    @purchases_by_person = @purchases_by_person.pending if params[:pending] == '1'
  end

  def set_person
    @person = Person.find(params[:person_id])
  end

end
