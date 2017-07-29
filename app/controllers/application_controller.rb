class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    if self.action_name != "destroy"
      redirect_to request.referrer || root_path
    else
      redirect_to root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar, :biography, :password, :password_confirmation])
  end

  def page
    params[:page] || 1
  end

  def redirect_back_with_anchor(anchor)
    redirect_to request.referer.present? ? request.referer + "##{anchor}" : root_path
  end
  
end
