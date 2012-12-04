require 'spec_helper'

describe SalesReturn do
  before(:each) do
    @admin = FactoryGirl.create(:user, :email => "admin@gmail.com", :password => "willy1234", :password_confirmation => "willy1234")
    @joko = FactoryGirl.create(:employee, :name => "Willy")
    @joko = FactoryGirl.create(:employee, :name => "Joko")
    @joni = FactoryGirl.create(:employee, :name => "Joni")
    
    @jakarta = FactoryGirl.create(:town, :name => "Jakarta")
    @lampung = FactoryGirl.create(:town, :name => "Lampung")
    
    @base_category = FactoryGirl.create(:category, :name => "Base") 
    @body_category = @base_category.create_sub_category( :name => "BodyPart")
    @engine_category = @base_category.create_sub_category( :name => "Engine")
    @lubricant_category = @engine_category.create_sub_category( :name => "Lubricant")
    
    @toyota_vendor = FactoryGirl.create(:vendor, :name => "Toyota Puri",
                        :contact_person => "Wilson",
                        :mobile => "08161437707")
    
    @bangjay_vendor = FactoryGirl.create(:vendor, :name => "Bangka Jaya",
                        :contact_person => "Rudi",
                        :mobile => "081612337707")
                        
    @shell_lubricant_5L = FactoryGirl.create(:item, :category_id => @lubricant_category.id , 
                          :recommended_selling_price => BigDecimal("50000"),
                          :name => "Shell Lubricant 5L"
              )
    
    @pertamina_lubricant_5L = FactoryGirl.create(:item, :category_id => @lubricant_category.id , 
                          :recommended_selling_price => BigDecimal("45000"),
                          :name => "Pertamina Lubricant 5L"
              )
              
    
    @willy = FactoryGirl.create(:customer,           :name => "Weyewe",
                                            :contact_person => "Willy",
                                            :town_id => @jakarta.id ) 

    @wilson = FactoryGirl.create(:customer,           :name => "Alfindo",
                                              :contact_person => "Wilson Gozali" ,
                                              :town_id => @lampung.id) 
    
    @vios_b_1725_bad = @willy.new_vehicle_registration( @admin ,  :id_code => "B1725BAD")    
    @rush_b_1665_bsf = @willy.new_vehicle_registration( @admin , :id_code => "B 1725Bsf")    
    
    @lubricant_replacement = FactoryGirl.create(:service, :name => "Lubricant Replacement", 
                                                  :recommended_selling_price => BigDecimal("100000"),
                                                  :commission_per_employee => BigDecimal('10000')) 
                                                  
    # create some stock migrations 
    
    @pertamina_quantity = 5
    @pertamina_price = BigDecimal('150000')
    StockMigration.create_item_migration(@admin, @pertamina_lubricant_5L, 
          @pertamina_quantity,  @pertamina_price)
          
    @shell_quantity = 3
    @shell_price = BigDecimal('250000')
    StockMigration.create_item_migration(@admin, @shell_lubricant_5L, 
          @shell_quantity,  @shell_price)
  end
  
  context 'create sales return, only targeting 1 stock entry' do
    before(:each) do
      @sales_order =   SalesOrder.create_sales_order( @admin, @willy  )
      @pertamina_sales_price = @pertamina_price + BigDecimal("30000")
      # pertamina quantity = =5 
      @pertamina_sales_quantity = @pertamina_quantity - 2 
      @pertamina_sales_entry = @sales_order.add_sales_entry_item( @pertamina_lubricant_5L,  
                  @pertamina_sales_quantity , 
                  @pertamina_sales_price )
      @sales_order.confirm_sales(@admin)
      @sales_order.is_confirmed?.should be_true 
    end
    
    it 'should not allow creation if there is no sales invoice' do
      @sales_return = SalesReturn.create_sales_return( @admin, nil   )
      @sales_return.should be_nil 
    end
    
    it 'should  allow creation if there is  sales invoice' do
      @sales_return = SalesReturn.create_sales_return( @admin, @sales_order   )
      @sales_return.should be_valid 
    end
    
    it 'should not allow confirm return if there is no sales return entry' do 
      @sales_return = SalesReturn.create_sales_return( @admin, @sales_order   )
      @sales_return.confirm_return(@admin)
      
      @sales_return.is_confirmed?.should be_false 
    end
    
    it 'should  allow confirm return if there is  sales return entry' do 
      @sales_return = SalesReturn.create_sales_return( @admin, @sales_order   )
      
      @sales_return_entry =   @sales_return.add_sales_return_entry_item( @pertamina_lubricant_5L,    
                                                          1 , 
                                                          BigDecimal('50000') )
                                                          
                                                          
      @sales_return.confirm_return(@admin)
      
      @sales_return.is_confirmed?.should be_true 
    end
    
    context 'post sales return creation' do
      before(:each) do
        @sales_return = SalesReturn.create_sales_return( @admin, @sales_order   )
        @sales_return_entry =   @sales_return.add_sales_return_entry_item( @pertamina_lubricant_5L,    
                                                            1 , 
                                                            BigDecimal('50000') )
        @sales_return.confirm_return(@admin)
      end
      
      it 'should have been confirmed' do 
        @sales_return.is_confirmed?.should be_true 
      end
      
      
      it 'should create 1 stock mutation, and deduct 1 stock entry because of the quantity to be returned == 1' do
        
      end
    end
    
   
  end 
end
