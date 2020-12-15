class ApplicationController < ActionController::Base
  around_action :switch_locale

  def index
  end

  def view_conf
    @app_config = Rgmdwt::Configuration.get_config(params[:id])
  end

  def appli_dwt
    downtime = Array.new()
    target = Rgmdwt::Configuration.get_config(params[:id])
    target['app'].each do |app|
      Rgmdwt::Api.create_downtime(
        params[:description].first,
        DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
        DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S'),
        app['host'],
        app['service']
      )
      downtime.push Rgmdwt::Utils.generate_downtime_notif_data(
        'application', app['host'], app['service'], params[:description],
        DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
        DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S')
      )
    end
    target['hosts'].each do |host|
      specific_downtime = Array.new()
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
        downtime.push Rgmdwt::Utils.generate_downtime_notif_data(
          'service', host['host'], service, params[:description],
          DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
          DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S')
        )
        unless host['mails'].nil?
          specific_downtime.push Rgmdwt::Utils.generate_downtime_notif_data(
            'service', host['host'], service, params[:description],
            DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
            DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S')
          )
        end
      end
      downtime.push Rgmdwt::Utils.generate_downtime_notif_data(
        'host', host['host'], '-', params[:description],
        DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
        DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S')
      )
      unless host['mails'].nil?
        specific_downtime.push Rgmdwt::Utils.generate_downtime_notif_data(
          'service', host['host'], '-', params[:description],
          DateTime.parse(params[:startdate]).strftime('%d-%m-%Y %H:%M:%S'),
          DateTime.parse(params[:enddate]).strftime('%d-%m-%Y %H:%M:%S')
        )
        Notifications::SendService.call(specific_downtime,host['mails']['addresses']) if host['mails']['engine'] == 'internal'
      end
    end
    unless target['mails'].nil?
      Notifications::SendService.call(downtime,target['mails']['addresses']) if target['mails']['engine'] == 'internal'
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
