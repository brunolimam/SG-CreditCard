module ApplicationHelper
  def check_if_true(item)
  if(item == 'true' or item == true or item == 1 or item == '1')
    return true
  else
    return false
  end
  end

  def get_percent_used credit_card
    credit_card.purchases.purchases_pending.map(&:value_total_remaining).inject(0, :+)/credit_card.limit*100
  end
  
  def get_percent_used_all
    Purchase.purchases_pending.map(&:value_total_remaining).inject(0, :+)/CreditCard.all.map(&:limit).inject(0, :+)*100
  end

  def define_color_by_percent(percent)
    case percent
    when 85..100
      "progress-bar-danger"
    when 33..85
      "progress-bar-warning"
    else
      "progress-bar-success"
    end
  end
end
