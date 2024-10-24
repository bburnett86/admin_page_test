# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper Playbook::PbKitHelper
  before_action :authenticate_user!

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

  def validate_admin
    if current_user.nil?
      Rails.logger.debug "Current user is nil"
      render json: { error: 'Access denied' }, status: :forbidden
    elsif current_user.role != "admin"
      Rails.logger.debug "Current user role is not admin: #{current_user.role}"
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end

  def after_sign_out_path_for(resource_or_scope)

    new_user_session_path
  end
end
