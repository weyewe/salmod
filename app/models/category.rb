class Category < ActiveRecord::Base
  attr_accessible :name, :parent_id
  acts_as_nested_set
  
  validates_presence_of :name
  validates_uniqueness_of :name 
  
  def create_sub_category( category_params ) 
    new_category = Category.create(:name => category_params[:name],
                              :parent_id => self.id ) 
    return new_category
  end
end
