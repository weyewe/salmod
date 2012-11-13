module ApplicationHelper
  
  def print_money(value)
    if value.nil?
      number_with_delimiter( 0 , :delimiter => "." )
    else
      number_with_delimiter( value.to_i , :delimiter => "." )
    end 
  end 
  
  
end
