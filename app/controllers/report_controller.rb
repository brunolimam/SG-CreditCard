class ReportController < ApplicationController
	before_action :set_purchases, only: [:purchases_by_person]

  def prepare
  end

  def purchases
  end

  def purchases_by_month
  end

  def purchases_by_person  
      
     html = render_to_string(:action => 'pdf/purchases_by_person', :layout => false)
     kit = PDFKit.new(html,:footer_right => Time.now.strftime("%d/%m/%Y")+"-"+Time.now.strftime("%H:%M:%S"),:footer_left => '')     
     kit.stylesheets << "#{Rails.root}/vendor/assets/bootstrap.css"
     
      pdf = kit.to_pdf
      
      send_data pdf, :filename => Time.zone.today.to_s+'.pdf',
                :type => "application/pdf",
                :disposition  => "inline",
                :data => @purchases
  
  end

  def purchases_graphics
  	@purchases_by_month = Installment.group_by_month(:p_day, format: "%b/%y").sum(:value)
  end


  private 

  def set_purchases
  	@purchases = Purchase.purchases(params[:person_id])
  end


end
