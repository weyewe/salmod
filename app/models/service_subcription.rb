class ServiceSubcription < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :service_item 
  belongs_to :employee 
end
