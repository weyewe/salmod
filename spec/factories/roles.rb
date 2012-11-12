FactoryGirl.define do
  factory :role do
    name "The role"
  end
  
  factory :admin_role, parent: :role do 
    name USER_ROLE[:admin]
  end
  
  factory :purchasing_role, parent: :role do 
    name USER_ROLE[:purchasing]
  end
  
  factory :inventory_role, parent: :role do 
    name USER_ROLE[:inventory]
  end
  
  factory :sales_role , parent: :role do 
    name USER_ROLE[:sales]
  end
  
  factory :mechanic , parent: :role do 
    name USER_ROLE[:mechanic]
  end
end
