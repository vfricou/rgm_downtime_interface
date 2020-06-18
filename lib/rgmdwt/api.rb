module Rgmdwt
  class Api
    def self.build_payload(comment, start_time, end_time, hostname, service = nil)
      payload = {
          comment: comment,
          startTime: start_time,
          endTime: end_time,
          fixed: '1',
          user: Rails.configuration.rgmdwt[:submit_user],
          hostName: hostname
      }
​
      payload.merge!({ serviceName: service }) unless service.nil?
​
      payload
    end
​
    def self.create_downtime(type, payload = {})
      rgmapi_endpoint = type == 'service' ? 'createServiceDowntime' : 'createHostDowntime'
      rgmapi_url = "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/#{rgmapi_endpoint}?token=#{self.api_token}"
​
      api_endpoint = RestClient::Resource.new(rgmapi_url, verify_ssl: OpenSSL::SSL::VERIFY_NONE)
      api_endpoint.post(payload.to_json, { content_type: 'application/json' })
    end
​
    private
​
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