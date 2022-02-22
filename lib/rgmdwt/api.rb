module Rgmdwt
  class Api
    def self.create_downtime(comment, start_time, end_time, hostname, service = nil)
      rgmapi_endpoint = service.nil? ? 'createHostDowntime' : 'createServiceDowntime'
      @payload = Utils.dwt_payload(comment, start_time, end_time, hostname, service)
      token=Utils.api_token
      api_request = RestClient::Resource.new(
        "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/#{rgmapi_endpoint}?token=#{token}",
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).post(@payload.to_json, { content_type: 'application/json' })
    end

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
      token = Utils.api_token
      dwt_entry = JSON.parse(
        RestClient::Resource.new(
          "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/listNagiosObjects?token=#{token}",
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
        ).post(@request.to_json, { content_type: 'application/json' }).body
      )
      unless dwt_entry['result']['default'].first.nil?
        return dwt_entry['result']['default'].first
      end
    end
  end
end
