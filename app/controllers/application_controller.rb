class ApplicationController < ActionController::Base
  around_action :switch_locale

  def index
  end

  def view_conf
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end

  def appli_dwt
    target = Rgmdwt::Configuration.get_config(params[:id])
    target['app'].each do |app|
      Rgmdwt::Api.create_downtime(
        params[:description].first,
        DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
        DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S'),
        app['host'],
        app['service']
      )
    end
    target['hosts'].each do |host|
      Rgmdwt::Api.create_downtime(
        params[:description].first,
        DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
        DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S'),
        host['host']
      )
      host['services']&.each do |service|
        Rgmdwt::Api.create_downtime(
          params[:description].first,
          DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
          DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S'),
          host['host'],
          service
        )
      end
    end

    redirect_to view_dwt_result_path(params[:id]), notice: 'Downtime was successfully created.'

  end

  def view_dwt
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end

  def view_dwt_result
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end

  protected

  def switch_locale(&action)
    locale = I18n.locale_available?(params[:locale]) ? params[:locale] : I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
