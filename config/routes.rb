Salmod::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
  end

  root :to => 'home#index'
  root :to => 'home#login'
  
  resources :categories 
  resources :items 
  
  
  resources :stock_migrations 
  match 'search_item'  => 'items#search_item' , :as => :search_item
  match 'search_service' => 'services#search_service', :as => :search_service
  match 'generate_stock_migration'  => 'stock_migrations#generate_stock_migration' , :as => :generate_stock_migration, :method => :post 
  
  
  
=begin
  Creating Sales Order
=end
  resources :customers 
  resources :sales_orders do
    resources :sales_entries 
  end
  resources :purchase_orders do
    resources :purchase_entries  
  end
  
  # employee management 
  resources :employees
  resources :vendors 

  match 'generate_sales_order'  => 'sales_orders#generate_sales_order' , :as => :generate_sales_order, :method => :post 
  match 'search_vehicle'  => 'vehicles#search_vehicle' , :as => :search_vehicle
  match 'search_customer' => "customers#search_customer", :as => :search_customer 
  match 'search_vendor' => "vendors#search_vendor", :as => :search_vendor 
  
=begin
  Adding Sales Entry
=end
  match 'generate_sales_entry_add_product_form' => 'sales_entries#generate_sales_entry_add_product_form', :as => :generate_sales_entry_add_product_form, :method => :post 
  match 'generate_sales_entry_add_service_form' => 'sales_entries#generate_sales_entry_add_service_form', :as => :generate_sales_entry_add_service_form, :method => :post 
  
  match 'create_service_sales_entry/:sales_order_id' => 'sales_entries#create_service_sales_entry', :as => :create_service_sales_entry , :method => :post 

=begin
  Editing sales entry 
=end
  match 'update_sales_entry/:sales_order_id/sales_entry/:id' => 'sales_entries#update_sales_entry', :as => :update_sales_entry, :method => :post 
  match 'update_sales_entry_service/:sales_order_id/sales_entry/:id' => 'sales_entries#update_sales_entry_service', :as => :update_sales_entry_service, :method => :post 
  
   
=begin
  DELETE Sales Entry
=end
  match 'delete_sales_entry_from_sales_order/:sales_order_id' => 'sales_entries#delete_sales_entry_from_sales_order', :as => :delete_sales_entry_from_sales_order, :method => :post 


=begin
  CONFIRM SALES ORDER 
=end
  match 'confirm_sales_order/:sales_order_id' => "sales_orders#confirm_sales_order", :as => :confirm_sales_order, :method => :post 
  match 'delete_sales_order/:sales_order_id' => "sales_orders#delete_sales_order", :as => :delete_sales_order, :method => :post 
  
##################################################
##################################################
######### Create PURCHASE ORDER + ENTRIES 
##################################################
##################################################


=begin
  Adding Purchase Entry
=end
  match 'generate_purchase_entry_add_product_form' => 'purchase_entries#generate_purchase_entry_add_product_form', :as => :generate_purchase_entry_add_product_form, :method => :post 
 

=begin
  Editing Purchase Entry
=end
  match 'update_purchase_entry/:purchase_order_id/purchase_entry/:id' => 'purchase_entries#update_purchase_entry', :as => :update_purchase_entry, :method => :post

=begin
  DELETE PurchaseEntry
=end
  match 'delete_purchase_entry_from_purchase_order/:purchase_order_id' => 'purchase_entries#delete_purchase_entry_from_purchase_order', :as => :delete_purchase_entry_from_purchase_order, :method => :post 

   
##################################################
##################################################
######### EMPLOYEE PERFORMANCE THROUGH SERVICE ITEMS 
##################################################
##################################################
   match 'service_done_by_employee/:employee_id' => 'service_items#service_done_by_employee', :as => :service_done_by_employee
   
   
end
