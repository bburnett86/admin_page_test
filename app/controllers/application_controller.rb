# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper Playbook::PbKitHelper

  def index; end

  # def validate_customer_service_min
  # 	return if ["customer service", "manager", "admin"].include?(current_user.role)
  # 	flash[:alert] = "You do not have permission to access this page"
  # 	redirect_to root_path
  # end

  # def validate_manager_min
  # 	return if ["manager", "admin"].include?(current_user.role)
  # 	flash[:alert] = "You do not have permission to access this page"
  # 	redirect_to root_path
  # end

  # def validate_admin
  # 	unless current_user.role == "admin"
  # 		render json: { error: 'Access denied' }, status: :forbidden
  # 	end
  # end

  # def after_sign_in_path_for(resource)
  #   # Custom logic here
  #   # Example: Redirect admins to the admin dashboard, others to the home page
  #   return admin_dashboard_path if resource.is_a?(User) && resource.admin?
  #   super
  # end

  # def after_sign_out_path_for
  #   # Custom logic here
  #   # Example: Redirect to the welcome page after sign out
  #   welcome_path
  # end
end
