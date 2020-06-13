class ApplicationController < ActionController::Base
  around_action :switch_locale

  def index
  end

  protected

  def switch_locale(&action)
    locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
