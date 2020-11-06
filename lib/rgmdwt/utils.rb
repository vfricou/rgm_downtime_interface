module Rgmdwt
  class Utils
    def self.dwt_payload(comment, start_time, end_time, hostname, service = nil)
      @payload = {
          comment: comment,
          startTime: start_time,
          endTime: end_time,
          fixed: '1',
          user: Rails.configuration.rgmdwt[:submit_user],
          hostName: hostname
      }
      @payload.merge!({ serviceName: service }) unless service.nil?
      return @payload
    end

    def self.api_token
      JSON.parse(
        RestClient::Resource.new(
          "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/getAuthToken?&username=#{Rails.configuration.rgmdwt[:api_username]}&password=#{Rails.configuration.rgmdwt[:api_password]}",
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
        ).get().body
      )['RGMAPI_TOKEN']
    end

    def self.generate_downtime_notif_data(type,host,service,cause,startdate,enddate)
      downtime_data = Hash.new()
      downtime_data['type'] = type
      downtime_data['cause'] = cause
      downtime_data['startdate'] = startdate
      downtime_data['enddate'] = enddate
      if type == 'application'
        downtime_data['level'] = host
        downtime_data['app'] = service
      else
        downtime_data['host'] = host
        downtime_data['service'] = service
      end
      return downtime_data
    end
  end
end
