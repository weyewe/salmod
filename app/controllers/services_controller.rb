class ServicesController < ApplicationController
  def search_service
    # verify the current_user 
    search_params = params[:q]
    
    @services = [] 
    service_query = '%' + search_params + '%'
    # on PostGre SQL, it is ignoring lower case or upper case 
    @services = Service.where{ (name =~ service_query)  }.map{|x| {:name => x.name, :id => x.id }}
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
      format.json { render :json => @services }
    end
  end
end
