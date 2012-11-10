class Customer < ActiveRecord::Base
  attr_accessible :name, :contact_person, :phone, :mobile , :email, :bbm_pin, :address
  has_many :vehicles 
  
  validates_presence_of :name 
  validates_uniqueness_of :name
  
  def new_vehicle_registration( employee ,  vehicle_params ) 
    id_code = vehicle_params[:id_code]
    if not id_code.present? 
      return nil
    end
    
    
    self.vehicles.create :id_code =>  id_code.upcase.gsub(/\s+/, "") 
  end
end
