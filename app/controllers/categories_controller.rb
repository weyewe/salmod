class CategoriesController < ApplicationController
  def new
    @categories = Category.all 
    @new_category = Category.new 
  end
  
  def create
    base_category = Category.find_by_id params[:category][:parent_id]
    
    @new_category = base_category.create_sub_category( params[:category] ) 
  end
  
end
