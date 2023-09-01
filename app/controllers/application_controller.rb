class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :password])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :first_name, :last_name, :birthdate, :gender_id, :custom_gender])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :password, :current_password, :password, :first_name, :last_name, :birthdate, :gender_id, :custom_gender])
  end

  def after_sign_in_path_for(resource)
    "/offers"
  end
end
