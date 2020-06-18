class ApplicationController < ActionController::Base
  around_action :switch_locale

  def index
  end

  def view_conf
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end

  def appli_dwt
    @app_config = Rgmdwt::Api.set_downtime(params[:id],params[:form])
  end

  protected

  def switch_locale(&action)
    locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
