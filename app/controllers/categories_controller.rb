class CategoriesController < ApplicationController
  def new
    @categories = Category.active_categories 
    @new_category = Category.new 
  end
  
  def create
    base_category = Category.find_by_id params[:category][:parent_id]
    
    # sleep 5
    
    @object = base_category.create_sub_category( params[:category] ) 
    if @object.valid?
      @new_object=  Category.new
    else
      @new_object= @object
    end
    
  end
  
end
