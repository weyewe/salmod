class Item < ActiveRecord::Base
  attr_accessible :name
  has_many :stock_entry 
  
  validates_uniqueness_of :name
  validates_presence_of :name 
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
  
end
