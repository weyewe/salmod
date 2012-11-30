class StockMutation < ActiveRecord::Base
  attr_accessible :quantity, :stock_entry_id, :source_document_entry_id, 
                  :creator_id, :source_document_id, :source_document_entry,
                  :source_document, :deduction_case,
                  :mutation_case, :mutation_status,
                  :item_id, :item_status

  belongs_to :stock_entry 
  belongs_to :scrap_item 
  belongs_to :item
  
  
=begin
  For normal purchase: reducing the stock 
=end
  def StockMutation.deduct_ready_stock(
          employee, 
          quantity, 
          item, 
          source_document, 
          source_document_entry,
          mutation_case, 
          mutation_status  
        )
        
      requested_quantity =  quantity
      supplied_quantity = 0 

      while supplied_quantity != requested_quantity
        unfulfilled_quantity = requested_quantity - supplied_quantity 
        stock_entry =  StockEntry.first_available_stock(  item )

        #  stock_entry.nil? raise error  # later.. 
        if stock_entry.nil?
          raise ActiveRecord::Rollback, "Can't be executed. No Item in the stock" 
        end

        available_quantity = stock_entry.available_quantity 

        served_quantity = 0 
        if unfulfilled_quantity <= available_quantity 
          served_quantity = unfulfilled_quantity 
        else
          served_quantity = available_quantity 
        end

        stock_entry.update_usage(served_quantity) 
        supplied_quantity += served_quantity 

        StockMutation.create(
          :quantity            => served_quantity  ,
          :stock_entry_id      =>  stock_entry.id ,
          :creator_id          =>  employee.id ,
          :source_document_entry_id  =>  source_document_entry.id  ,
          :source_document_id  =>  source_document.id  ,
          :source_document_entry     =>  source_document_entry.class.to_s,
          :source_document    =>  source_document.class.to_s,
          :mutation_case      => mutation_case,
          :mutation_status => mutation_status,
          :item_id => stock_entry.item_id ,
          :item_status => ITEM_STATUS[:ready]
        )

      end
  end 
  
=begin
  For SALES RETURN: recover stock to the respective FIFO stock entry 
=end 

  def StockMutation.stock_mutations_for_sales_entry(sales_entry)  
    sales_order = sales_entry.sales_order
    StockMutation.where(
      :source_document_entry_id  =>  sales_entry.id  ,
      :source_document_id  =>  sales_order.id  ,
      :source_document_entry     =>  sales_entry.class.to_s,
      :source_document    =>  sales_order.class.to_s,
      :mutation_case      => MUTATION_CASE[:sales_order],
      :mutation_status => MUTATION_STATUS[:deduction],
      :item_status => ITEM_STATUS[:ready]
    ).order("created_at ASC")        # the order is to preserve the FIFO # the first stock mutation refers to the first item in ready stock
  end
  
  def StockMutation.recover_stock_from_sales_return( employee, sales_return_entry) 
    pending_recovery_quantity = sales_return_entry.quantity 
    
    sales_entry = sales_return_entry.sales_entry 
      
    StockMutation.stock_mutations_for_sales_entry(sales_entry).each do |stock_mutation|
      stock_entry = stock_mutation.stock_entry 
      deducted_quantity = stock_mutation.quantity
      
      quantity_to_be_recovered =  0 
      
      if deducted_quantity >= pending_recovery_quantity
        # it means this is the last stock_entry to be recovered
        quantity_to_be_recovered = pending_recovery_quantity
      else
        quantity_to_be_recovered = deducted_quantity
      end
      
      stock_entry.recover_usage(quantity_to_be_recovered) 
      pending_recovery_quantity -= quantity_to_be_recovered 
      
      StockMutation.create(
        :quantity            => quantity_to_be_recovered  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  sales_return_entry.id  ,
        :source_document_id  =>  sales_return_entry.sales_return_id  ,
        :source_document_entry     =>  sales_return_entry.class.to_s,
        :source_document    =>  sales_return_entry.sales_return.class.to_s,
        :mutation_case      => MUTATION_CASE[:sales_return],
        :mutation_status => MUTATION_STATUS[:addition],
        :item_id => stock_entry.item_id,
        :item_status => ITEM_STATUS[:ready]
      )
    end
  end

=begin
  FOR SCRAP ITEM 
=end
  def StockMutation.deduct_ready_stock_add_scrap_item( employee, scrap_item) 
    
    requested_quantity =  scrap_item.quantity 
    supplied_quantity = 0 
    
    item = scrap_item.item 

    while supplied_quantity != requested_quantity
      unfulfilled_quantity = requested_quantity - supplied_quantity 
      stock_entry =  StockEntry.first_available_stock(  item )

      #  stock_entry.nil? raise error  # later.. 
      if stock_entry.nil?
        raise ActiveRecord::Rollback, "Can't be executed. No Item in the stock" 
      end

      available_quantity = stock_entry.available_quantity 

      served_quantity = 0 
      if unfulfilled_quantity <= available_quantity 
        served_quantity = unfulfilled_quantity 
      else
        served_quantity = available_quantity 
      end

      stock_entry.update_usage(served_quantity) 
      supplied_quantity += served_quantity 

      deduct_ready_stock_mutation = StockMutation.create(
        :quantity            => served_quantity  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  scrap_item.id  ,
        :source_document_id  =>  scrap_item.id  ,
        :source_document_entry     =>  scrap_item.class.to_s,
        :source_document    =>  scrap_item.class.to_s,
        :mutation_case      => MUTATION_CASE[:scrap_item],
        :mutation_status => MUTATION_STATUS[:deduction],
        :item_id => stock_entry.item_id ,
        :item_status => ITEM_STATUS[:ready]
      )
      
      
      item.add_scrap_quantity( served_quantity ) 
      scrap_item_stock_mutation = StockMutation.create(
        :quantity            => served_quantity  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  scrap_item.id  ,
        :source_document_id  =>  scrap_item.id  ,
        :source_document_entry     =>  scrap_item.class.to_s,
        :source_document    =>  scrap_item.class.to_s,
        :mutation_case      => MUTATION_CASE[:scrap_item],
        :mutation_status => MUTATION_STATUS[:addition],
        :item_id => stock_entry.item_id ,
        :item_status => ITEM_STATUS[:scrap]
      )

    end
    
  end
  
  
=begin
  SCRAP ITEM REPLACEMENT
=end
  def StockMutation.deduct_scrap_add_ready_stock(  employee,  ex_scrap_item )
    # create several stock mutations to deduct scrap item
    # create several stock mutations to add scrap item    >>>> TO PRESERVE THE FIFO
    
    
    requested_quantity =  ex_scrap_item.quantity 
    exchanged_quantity = 0 
    
    item = ex_scrap_item.item 

    while exchanged_quantity != requested_quantity
      pending_exchange_quantity  = requested_quantity - exchanged_quantity 
      # stock_entry =  StockEntry.first_available_stock(  item )
      scrap_item  = ScrapItem.first_available_stock( item  )

      #  stock_entry.nil? raise error  # later.. 
      if scrap_item.nil?
        raise ActiveRecord::Rollback, "Can't be executed. No Scrap Item in the stock" 
      end

      unexchanged_quantity = scrap_item.unexchanged_quantity 

      served_quantity = 0 
      if pending_exchange_quantity <= unexchanged_quantity 
        served_quantity = pending_exchange_quantity 
      else
        served_quantity = unexchanged_quantity 
      end

      scrap_item.exchange_scrap(served_quantity)  
      exchanged_quantity += served_quantity 
      
      item.deduct_scrap_quantity( served_quantity ) 
      # deduct the scrap item
      deduct_scrap_stock_mutation = StockMutation.create(
        :quantity            => served_quantity  ,
        :stock_entry_id      =>  nil ,
        :scrap_item_id => scrap_item.id , 
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  scrap_item.id  ,
        :source_document_id  =>  scrap_item.id  ,
        :source_document_entry     =>  scrap_item.class.to_s,
        :source_document    =>  scrap_item.class.to_s,
        :mutation_case      => MUTATION_CASE[:scrap_item_replacement],
        :mutation_status => MUTATION_STATUS[:deduction],
        :item_id => stock_entry.item_id ,
        :item_status => ITEM_STATUS[:scrap]
      )
      
      
      
      # add the ready item 
      # since this is replacement, we have to treat it like sales return.. 
      # find the exact stock entry. recover it.
      item.add_ready_quantity( served_quantity ) 
      scrap_item_stock_mutation = StockMutation.create(
        :quantity            => served_quantity  ,
        :stock_entry_id      =>  stock_entry.id ,
        :creator_id          =>  employee.id ,
        :source_document_entry_id  =>  scrap_item.id  ,
        :source_document_id  =>  scrap_item.id  ,
        :source_document_entry     =>  scrap_item.class.to_s,
        :source_document    =>  scrap_item.class.to_s,
        :mutation_case      => MUTATION_CASE[:scrap_item_replacement],
        :mutation_status => MUTATION_STATUS[:addition],
        :item_id => stock_entry.item_id ,
        :item_status => ITEM_STATUS[:ready]
      )

    end
  end
  
  
  
end
