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
    def self.create_host_downtime(comment,startDT,endDT,user,host)
      api_token = self.init_token
      createHostDwtURL = "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/createHostDowntime?token=#{api_token}"

      payload = {
        "comment"=>"#{comment}",
        "startTime"=>"#{startDT}",
        "endTime"=>"#{endDT}",
        "fixed"=>"1",
        "user"=>"#{user}",
        "hostName"=>"#{host}"
      }

      post_host_state = RestClient::Resource.new(
		    createHostDwtURL,
		    :verify_ssl =>  OpenSSL::SSL::VERIFY_NONE
	    ).post(
        payload.to_json, {
          content_type: 'application/json'
        }
      )
    end
    def self.create_service_downtime(comment,startDT,endDT,user,host,service)
      api_token = self.init_token
      createHostDwtURL = "https://#{Rails.configuration.rgmdwt[:api_server]}/rgmapi/createServiceDowntime?token=#{api_token}"

      payload = {
        "comment"=>"#{comment}",
        "startTime"=>"#{startDT}",
        "endTime"=>"#{endDT}",
        "fixed"=>"1",
        "user"=>"#{user}",
        "hostName"=>"#{host}",
        "serviceName"=>"#{service}"
      }

      post_host_state = RestClient::Resource.new(
		    createHostDwtURL,
		    :verify_ssl =>  OpenSSL::SSL::VERIFY_NONE
	    ).post(
        payload.to_json, {
          content_type: 'application/json'
        }
      )
    end
  end
end