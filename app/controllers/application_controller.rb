class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  #

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :username
      devise_parameter_sanitizer.for(:account_update) << :username
    end

  private
    # Doesn't seem to be able to redirect for an unknown reason as of yet.
    #def after_sign_in_path_for(resource_or_scope)
    #  request.referrer || root_path
    #end

    def after_sign_out_path_for(resource_or_scope)
      request.referrer || root_path
    end

end
