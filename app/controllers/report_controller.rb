class ReportController < ApplicationController
	before_action :set_purchases, only: [:purchases_person_by_person,:purchases_by_person,:purchases]

  def prepare
  end

  def purchases
    set_pdf_data 'pdf/purchases',@purchases 
  end

  def purchases_person_by_person
    set_pdf_data 'pdf/purchases_person_by_person',@purchases 
  end

  def purchases_by_month
  end

  def purchases_by_person  
    set_person
    set_pdf_data 'pdf/purchases_by_person',@purchases_by_person  
  end

  def purchases_graphics
  	@purchases_by_month = Installment.group_by_month(:p_day, format: "%b/%y").sum(:value)
  end


  def set_pdf_data action,data
     html = render_to_string(:action => action, :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => '',:orientation => 'Landscape')     
     kit.stylesheets << "#{Rails.root}/vendor/assets/bootstrap.css"
     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => data
  end


  private 

  def set_purchases
    sort = params[:sort]
    order = params[:order]    
  	
    @purchases = Purchase.order(sort+' '+order).all
    @purchases_by_person = @purchases.purchases(params[:person_id])
  end

  def set_person
    @person = Person.find(params[:person_id])
  end

end
