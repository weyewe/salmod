module ApplicationHelper
  
  def print_money(value)
    if value.nil?
      number_with_delimiter( 0 , :delimiter => "." )
    else
      number_with_delimiter( value.to_i , :delimiter => "." )
    end 
  end 
  
  def get_checkbox_value(checkbox_value )
    if checkbox_value == true
      return TRUE_CHECK
    else
      return FALSE_CHECK
    end
  end
  
  
end
