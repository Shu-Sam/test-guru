class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  
  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { lang: I18n.locale }
  end
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name surname])
  end

  private

  def set_locale
    I18n.locale = I18n.locale_available?(params[:lang]) ? params[:lang] : I18n.default_locale
  end
end
