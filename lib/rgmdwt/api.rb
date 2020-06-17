module Rgmdwt
  class Api
    def self.init_token
      getTokenURL = "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/getAuthToken?&username=#{Rails.configuration.rgmdwt[:api_username]}&password=#{Rails.configuration.rgmdwt[:api_password]}"

      jsonGetToken = JSON.parse(
        RestClient::Resource.new(
          getTokenURL,
          :verify_ssl =>  OpenSSL::SSL::VERIFY_NONE
        ).get().body
      )
      return jsonGetToken['RGMAPI_TOKEN']
    end
  end
end