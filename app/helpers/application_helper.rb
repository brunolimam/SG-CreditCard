module ApplicationHelper
  def check_if_true(item)
  if(item == 'true' or item == true or item == 1 or item == '1')
    return true
  else
    return false
  end
  end

  def get_percent_used
    Purchase.purchases_pending.map(&:value_total_remaining).inject(:+)/Setting.limit_card*100
  end
  
  def define_color_by_percent
    case get_percent_used
    when 85..100
      "progress-bar-danger"
    when 33..85
      "progress-bar-warning"
    else
      "progress-bar-success"
    end
  end
end
