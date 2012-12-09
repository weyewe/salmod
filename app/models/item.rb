class Item < ActiveRecord::Base
  attr_accessible :name, :recommended_selling_price, :category_id
  has_many :stock_entry 
  
  belongs_to :category 
  
  has_many :service_items, :through => :replacement_items 
  has_many :replacement_items
  has_many :stock_mutations
  has_many :scrap_items
  has_many :exchange_scrap_items 
  has_many :conversion_entries
  has_many :stock_adjustments
  
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
    item.recommended_selling_price = BigDecimal("#{item_params[:recommended_selling_price]}")
    item.save
    return item 
  end
  
  
  def add_stock_and_recalculate_average_cost_post_stock_entry_addition( new_stock_entry ) 
    
    
    
    total_amount = ( self.average_cost * self.ready)   + 
                   ( new_stock_entry.base_price_per_piece * new_stock_entry.quantity ) 
                  
    total_quantity = self.ready + new_stock_entry.quantity 
    
    if total_quantity == 0 
      self.average_cost = BigDecimal('0')
    else
      self.average_cost = total_amount / total_quantity .to_f
    end
    self.ready = total_quantity 
    self.save 
    
  end
  
  def delete
    self.is_deleted = true
    self.save 
  end
  
 
=begin
  BECAUSE OF SALES
=end
  def deduct_ready_quantity( quantity)
    self.ready -= quantity 
    self.save
  end
  
  def add_ready_quantity( quantity ) 
    self.ready += quantity 
    self.save
  end
  
=begin
  BECAUSE OF SCRAP -> SCRAP EXCHANGE
=end
  
  def deduct_scrap_quantity( quantity )
    self.scrap -= quantity 
    self.ready += quantity 
    self.save
  end
  
  def add_scrap_quantity( quantity ) 
    self.scrap += quantity 
    self.ready -= quantity 
    self.save 
  end
  
end
