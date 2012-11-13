class ItemsController < ApplicationController
  def new
    @objects = Item.active_items
    @new_object = Item.new 
  end
  
  def create 
    @category = Category.find_by_id params[:item][:category_id]
    
    @object = Item.create_by_category( @category, params[:item])
    
    
    if @object.valid?
      @new_object=  Item.new
    else
      @new_object= @object
    end 
  end
  
  def search_item
    
    # verify the current_user 
    search_params = params[:q]
    
    @items = [] 
    item_query = '%' + search_params + '%'
    # on PostGre SQL, it is ignoring lower case or upper case 
    @items = Item.where{ (name =~ item_query)  }.map{|x| {:name => x.name, :id => x.id }}
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
      format.json { render :json => @items }
    end 
  end
  
  
end
