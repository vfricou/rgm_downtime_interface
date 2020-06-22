module Rgmdwt
  class Api

    def initialize(comment, start_time, end_time, hostname, service = nil)
      @payload = {
        comment: comment,
        startTime: start_time,
        endTime: end_time,
        fixed: '1',
        user: Rails.configuration.rgmdwt[:submit_user],
        hostName: hostname
      }
      @payload.merge!({ serviceName: service }) unless service.nil?
    end

    def create_downtime(type)
      rgmapi_endpoint = type == 'service' ? 'createServiceDowntime' : 'createHostDowntime'
      RestClient::Resource.new(
        "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/#{rgmapi_endpoint}?token=#{api_token}",
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      ).post(@payload.to_json, { content_type: 'application/json' })
    end

    private

    def api_token
      JSON.parse(
        RestClient::Resource.new(
          "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/getAuthToken?&username=#{Rails.configuration.rgmdwt[:api_username]}&password=#{Rails.configuration.rgmdwt[:api_password]}",
          verify_ssl: OpenSSL::SSL::VERIFY_NONE
        ).get().body
      )['RGMAPI_TOKEN']
    end
  end
end