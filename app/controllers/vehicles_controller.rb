class VehiclesController < ApplicationController
  def search_vehicle
    search_params = params[:q]
    if search_params.nil?
      return nil
    else
      search_params= search_params.upcase.gsub(/\s+/, "") 
    end
    
    @vehicles = [] 
    item_query = '%' + search_params + '%'
    # on PostGre SQL, it is ignoring lower case or upper case 
    @vehicles = Vehicle.where{ (id_code =~ item_query)  }.map{|x| {:name => x.id_code, :id => x.id }}
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vehicles }
      format.json { render :json => @vehicles }
    end
  end
  
end
