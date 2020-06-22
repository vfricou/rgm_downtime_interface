module Rgmdwt
  class Listnagiosobject
    def self.get_downtime(hostname, service = nil)
      @request = {
        object: 'downtimes',
        columns: [
          'host_name', 'service_description', 'comment',
          'entry_time', 'start_time', 'end_time'
        ]
      }
      if service == '-'
        @request.merge!({filters: ["host_name = #{hostname}", "service_description = "]})
      else
        @request.merge!({filters: ["host_name = #{hostname}", "service_description = #{service}"]})
      end
      dwt_entry = JSON.parse(
          RestClient::Resource.new(
            "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/listNagiosObjects?token=#{Utils.api_token}",
            verify_ssl: OpenSSL::SSL::VERIFY_NONE
          ).post(@request.to_json, { content_type: 'application/json' }).body
      )
      puts dwt_entry.inspect
      unless dwt_entry['result']['default'].first.nil?
        return dwt_entry['result']['default'].first
      end
    end
  end

  class Utils
    def self.api_token
      JSON.parse(
        RestClient::Resource.new(
          "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/getAuthToken?&username=#{Rails.configuration.rgmdwt[:api_username]}&password=#{Rails.configuration.rgmdwt[:api_password]}",
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
        ).get().body
      )['RGMAPI_TOKEN']
    end
  end
end
