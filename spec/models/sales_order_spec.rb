require 'spec_helper'

describe SalesOrder do
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
  
  context 'creating the sales order' do
    it 'should allow creation if customer is nil' do
      sales_order = SalesOrder.create_sales_order( @admin,  nil   )
      sales_order.should be_valid 
      sales_order.customer_id.should be_nil 
      
      
    end
     
    
    it 'should allow creation if customer  is not nil'   do
      sales_order = SalesOrder.create_sales_order( @admin, @willy   )
      sales_order.should be_valid 
      sales_order.customer_id.should == @willy.id
    end
    
    it 'should not allow confirmation if there is no sales entry' do
      @sales_order = SalesOrder.create_sales_order( @admin, @willy  )
      result = @sales_order.confirm_sales( @admin ) 
      result.should be_nil 
      @sales_order.is_confirmed?.should be_false 
    end
     
    
  end
  
  # 1. adding sales_entry -> the logic for CRUD is locked  in sales_entry_spec.rb 
  context "sales_invoice confirmation" do 
    before(:each) do
      # create the sales order 
      @sales_order = SalesOrder.create_sales_order( @admin, @willy  )
      @sales_order_shell_price = @shell_price + BigDecimal('40000')
      @sales_order_shell_quantity =  @shell_quantity -1  
      @sales_order_pertamina_price = @pertamina_price - BigDecimal('10000')
      @sales_order_pertamina_quantity = @pertamina_quantity -1
      @shell_sales_entry = @sales_order.add_sales_entry_item( @shell_lubricant_5L,  @sales_order_shell_quantity  ,@sales_order_shell_price )
      @pertamina_sales_entry = @sales_order.add_sales_entry_item( @pertamina_lubricant_5L,  @sales_order_pertamina_quantity , @sales_order_pertamina_price )          
      
      @initial_shell_ready = @shell_lubricant_5L.ready 
      @initial_pertamina_ready =    @pertamina_lubricant_5L.ready
                                        
    end
    
    it 'should produce total price based on the given custom price' do
      @total_price = BigDecimal('0')
      @total_price += @sales_order_shell_quantity * @sales_order_shell_price
      @total_price += @sales_order_pertamina_quantity * @sales_order_pertamina_price 
      @sales_order.total_amount_to_be_paid.should == @total_price
    end
    
    it 'should allow confirmation if there is quantity available' do
      @result = @sales_order.confirm_sales( @admin)  
      @sales_order.is_confirmed?.should be_true  
    end
    
    context 'item ready is finished by competing confirmation sales order' do
      before(:each) do
        @competing_sales_order = SalesOrder.create_sales_order( @admin, @wilson  ) 
        @shell_lubricant_5L.reload
        @pertamina_lubricant_5L.reload 
        # puts "this is the competing bomb\n"*10
        
        # puts "******* #{@shell_lubricant_5L.name}, ready: #{@shell_lubricant_5L.ready}, requested: #{@shell_lubricant_5L.ready }"
        @competing_shell_sales_entry = @competing_sales_order.add_sales_entry_item( @shell_lubricant_5L,  @shell_lubricant_5L.ready  ,@shell_price )
        @competing_pertamina_sales_entry = @competing_sales_order.add_sales_entry_item( @pertamina_lubricant_5L,  @pertamina_lubricant_5L.ready , @pertamina_price )
        puts "Inspecting the shell sales entry\n"*10
        puts 'a'
        # puts "The length: #{@competing_shell_sales_entry.errors..length}"
        puts "The length: #{@competing_shell_sales_entry.errors.messages.length}"
        puts 'b'
        @competing_shell_sales_entry.errors.messages.each do |x|
          puts x 
        end
        @competing_shell_sales_entry.should be_valid
        @competing_pertamina_sales_entry.should be_valid
      
        @competing_sales_order.confirm_sales( @admin)  
        @competing_sales_order.is_confirmed?.should be_true 
        @shell_lubricant_5L.reload
        @pertamina_lubricant_5L.reload
        
        @shell_lubricant_5L.ready.should == 0 
        @pertamina_lubricant_5L.ready.should == 0
        
      end
      
      it 'should not allow the bypassed sales order, if the item.ready is less sales_entry.quantity' do
        @sales_order.confirm_sales(@admin)
        @sales_order.is_confirmed?.should be_false 
      end 
    end
    
    
    context 'confirmed sales order' do
      before(:each) do
        @sales_order.confirm_sales( @admin)  
        @shell_lubricant_5L.reload
        @pertamina_lubricant_5L.reload
      end
      
      it 'should not double confirm' do
        @result = @sales_order.confirm_sales( @admin)  
        @result.should be_nil 
      end
      
      it 'should deduct the item accordingly' do
        ( @initial_shell_ready - @shell_lubricant_5L.ready ).should == @shell_sales_entry.quantity
        ( @initial_pertamina_ready - @pertamina_lubricant_5L.ready ).should == @pertamina_sales_entry.quantity
      end
      
      # basic case, assume from single stock entry.. later on, more complicated case, from different stock entries 
      it 'should create at least 1 stock mutation for all product sales entry' do 
        @sales_order.active_sales_entries.where(:entry_case => SALES_ENTRY_CASE[:item] ).each do |sales_entry|
          StockMutation.where( 
            :source_document_entry_id  =>  sales_entry.id  ,
            :source_document_id  =>  @sales_order.id  ,
            :source_document_entry     =>  sales_entry.class.to_s,
            :source_document    =>  @sales_order.class.to_s,
            :mutation_case      =>MUTATION_CASE[:sales_order],
            :mutation_status => MUTATION_STATUS[:deduction],
            :item_id => sales_entry.entry_id ,
            :item_status => ITEM_STATUS[:ready]
          ).count == 1  
        end
      end
      
      it '[ACCOUNTING] should increase the cash, deduct the Inventory, add CoGS, add Revenue' # to bad, no accounting yet 
      
    end
    
    
    
  end
  
end
