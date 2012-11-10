class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
  layout :layout_by_resource
  def layout_by_resource
    if devise_controller? && resource_name == :user && action_name == 'new'
      "devise"
    else
      "application"
    end
  end
  
  def after_sign_in_path_for(resource)
    # active_job_attachment  = current_user.active_job_attachment 
    # if current_user.has_role?( :branch_manager, active_job_attachment)
    #   puts "user has role branch_manager!\n"*10
    #   return new_group_loan_product_url
    # end
    # 
    # if current_user.has_role?(:loan_officer, active_job_attachment)
    #   puts "user has role loan_officer!\n"*10
    #   return new_member_url
    # end
    # 
    # if current_user.has_role?(:field_worker, active_job_attachment)
    #   puts "user has role field_worker!\n"*10
    #   return select_group_loan_for_weekly_meeting_attendance_marking_url
    # end
    # 
    # if current_user.has_role?(:cashier, active_job_attachment)
    #   puts "user has role field_worker!\n"*10
    #   return select_group_loan_for_loan_disbursement_url
    # end
    
    return root_url 
    
  end
  
  
  
  
end
