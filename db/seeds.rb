# Create Office  
admin_role = Role.create :name => USER_ROLE[:admin]
purchasing_role = Role.create :name => USER_ROLE[:purchasing]
inventory_role = Role.create :name => USER_ROLE[:inventory]
sales_role = Role.create :name => USER_ROLE[:sales]  
mechanic_role = Role.create :name => USER_ROLE[:mechanic]


admin = User.create_main_user(   :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
admin.add_role_if_not_exists( admin_role ) 
admin.reload
 
# Create Employee  
# these 2 are mechanics 
joko = User.create(   :email => "joko@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234")
joko.add_role_if_not_exists( mechanic_role ) 

joni = User.create(   :email => "joni@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234")
joni.add_role_if_not_exists( mechanic_role )

 

                        
                        
# CREATE ITEM CATEGORY 
spare_part =  Category.create :name => "Spare Part" 

  body_part = spare_part.create_sub_category :name => "Body Part" 
    head_lamp = body_part.create_sub_category :name => "Head Lamp"
    radio_receiver = body_part.create_sub_category :name => "Radio Receiver"
    speaker = body_part.create_sub_category :name => "Speaker"
   
  engine_spare_part = spare_part.create_sub_category :name => "Spare Part Mesin"
    piston =   engine_spare_part.create_sub_category :name => "Piston"
    valve =   engine_spare_part.create_sub_category :name => "Valve"
    piston =   engine_spare_part.create_sub_category :name => "Piston"
    lubricant = engine_spare_part.create_sub_category :name => "Lubricant"
    shock_breaker = engine_spare_part.create_sub_category :name => "Shock Breaker"

  undercarriage = spare_part.create_sub_category :name => "Undercarriage"   
    combustion_pipe =   undercarriage.create_sub_category :name => "Piston"
                        
# Create VENDOR 
toyota_puri = Vendor.create :name => "Toyota Puri",
                    :contact_person => "Wilson",
                    :mobile => "08161437707"

bangjay = Vendor.create :name => "Bangjay", 
                        :contact_person => "Rudi",
                        :mobile => "0819 323 27 141"
                        
# Create Inventory Item 
shell_lubricant = Item.create( lubricant, :name => "Shell Formula 1 Lubricant 5L") 
pertamina_lubricant = Item.create( lubricant, :name => "Pertamina Top Gun 4L")
top_one_lubricant = Item.create( lubricant , :name => "Top One Indomobil 5L")

# Stock the inventory Item, using initial migration  
shell_quantity = 30
shell_price_per_item  =  BigDecimal('400000')
StockMigration.create_item_migration(admin, shell_lubricant, shell_quantity,  shell_price_per_item) 
shell_lubricant.reload 

pertamina_quantity = 20
pertamina_price_per_item  =  BigDecimal('350000')
pertamina_lubricant.create_item_migration(  admin,  pertamina_quantity, pertamina_price_per_item ) 
StockMigration.create_item_migration(admin, pertamina_lubricant, pertamina_quantity,  pertamina_price_per_item)
pertamina_lubricant.reload   

# create customer ( REGISTERED vehicle, it means )
willy = Customer.create :name => "Weyewe",
                    :contact_person => "Willy" 
                    
wilson = Customer.create :name => "Alfindo",
                    :contact_person => "Wilson Gozali" 
                    
vios_b_1725_bad_params = {
  :id_code => "B1725BAD"
} 
vios_b_1725_bad = willy.new_vehicle_registration( admin , willy, vehicle_params )    


=begin
  Create the basic sales case 
  1. new customer come, with unregistered broken car 
  2. create sales order
  3. add service fee  
=end    

# create sales order 
  ## LIST of items 
# create new customer on the fly ( in the pop up, i think)
# create maintenance on the fly ( in the pop up ) 


           
                  
 
