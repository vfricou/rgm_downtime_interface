class ApplicationController < ActionController::Base
  def index
  end
  
  def view_conf
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end
  
  around_action :switch_locale

  protected

  def switch_locale(&action)
    locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
