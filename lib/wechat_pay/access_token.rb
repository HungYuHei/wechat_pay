require 'json'
require 'rest_client'

module WechatPay
  module AccessToken
    def self.generate
      url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{WechatPay.app_id}&secret=#{WechatPay.app_secret}"

      RestClient.get(url) do |response|
        JSON.parse(response.body)
      end
    end
  end
end
