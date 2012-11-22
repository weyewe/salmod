class VendorsController < ApplicationController
 
  def new
    @objects = Vendor.active_vendors
    @new_object = Vendor.new 
  end

  def create
    @object = Vendor.create( params[:vendor] ) 
    if @object.valid?
      @new_object=  Vendor.new
    else
      @new_object= @object
      @objects =  Vendor.active_vendors
      render :file => 'vendors/new'
    end
  end

  def search_vendor
    search_params = params[:q]

    @objects = [] 
    query = '%' + search_params + '%'
    # on PostGre SQL, it is ignoring lower case or upper case 
    @objects = Vendor.where{ (name =~ query)  & (is_deleted.eq false) }.map{|x| {:name => x.name, :id => x.id }}

    respond_to do |format|
      format.html # show.html.erb 
      format.json { render :json => @objects }
    end
  end 
  
end
