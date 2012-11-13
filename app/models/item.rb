class Item < ActiveRecord::Base
  attr_accessible :name
  has_many :stock_entry 
  
  belongs_to :category 
  
  validates_uniqueness_of :name
  validates_presence_of :name 
  
  def self.active_items
    Item.where(:is_deleted => false).order("created_at DESC")
  end
=begin
  INITIAL MIGRATION 
=end 
  def Item.create_by_category(category, item_params) 
    item = Item.create :name => item_params[:name]
    
    if not item.valid?
      return item
    end
    
    item.category_id = category.id 
    item.save
    return item 
  end
  
  
  def recalculate_average_cost_post_stock_entry_addition( new_stock_entry ) 
    total_amount = self.average_cost * self.ready  + 
                  new_stock_entry.base_price_per_piece * new_stock_entry.quantity
                  
    total_quantity = self.ready + new_stock_entry.quantity 
    
    
    if total_quantity ==0 
      self.average_cost = BigDecimal('0')
    else
      self.average_cost = total_amount / total_quantity 
    end
    self.save 
    
  end
  
end
