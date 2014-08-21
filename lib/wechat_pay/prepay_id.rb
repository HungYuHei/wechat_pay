require 'json'
require 'rest_client'

module WechatPay
  module PrepayId
    module App

      # required params:
      #   traceid, noncestr, package, timestamp
      def self.generate(access_token, params)
        url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"
        app_signature = generate_app_signature(params)

        prepay_params = {
          appid:         WechatPay.app_id,
          app_signature: app_signature,
          traceid:       params[:traceid],
          noncestr:      params[:noncestr],
          package:       params[:package],
          timestamp:     params[:timestamp],
          sign_method:   'sha1'
        }

        RestClient.post(url, JSON.generate(prepay_params)) do |response|
          JSON.parse(response.body)['prepayid']
        end
      end

      private

      def self.generate_app_signature(signature_params)
        params = {
          appid: WechatPay.app_id,
          appkey: WechatPay.pay_sign_key,
          noncestr: signature_params[:noncestr],
          package: signature_params[:package],
          timestamp: signature_params[:timestamp],
          traceid: signature_params[:traceid]
        }

        Sign.sha1(params)
      end
    end
  end
end
