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
  match 'generate_stock_migration'  => 'stock_migrations#generate_stock_migration' , :as => :generate_stock_migration, :method => :post 
  
  
  
=begin
  Creating Sales Order
=end
  resources :customers 
  resources :sales_orders do
    resources :sales_entries 
  end

  match 'generate_sales_order'  => 'sales_orders#generate_sales_order' , :as => :generate_sales_order, :method => :post 
  match 'search_vehicle'  => 'vehicles#search_vehicle' , :as => :search_vehicle
  
=begin
  Adding Sales Entry
=end
  match 'generate_sales_entry_add_product_form' => 'sales_entries#generate_sales_entry_add_product_form', :as => :generate_sales_entry_add_product_form, :method => :post 
  
  
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
