require 'json'
require 'rest_client'

module WechatPay
  module OrderQuery
    def self.request(access_token, out_trade_no)
      url = "https://api.weixin.qq.com/pay/orderquery?access_token=#{access_token}"
      timestamp = Time.now.to_i.to_s
      package = generate_package(out_trade_no)
      app_signature = generate_app_signature(timestamp, package)

      data = {
        appid:         WechatPay.app_id,
        package:       package,
        timestamp:     timestamp,
        sign_method:   "sha1",
        app_signature: app_signature
      }

      RestClient.post(url, JSON.generate(data)) do |response|
        JSON.parse(response.body, symbolize_names: true)
      end
    end

    private

    def self.generate_package(out_trade_no)
      attrs = { out_trade_no: out_trade_no, partner: WechatPay.partner_id }
      package = attrs.sort.map { |item| item.join('=') }.join('&')
      "#{package}&sign=#{Sign.md5_with_partner_key(attrs)}"
    end

    def self.generate_app_signature(timestamp, package)
      Sign.sha1(
        appid:     WechatPay.app_id,
        appkey:    WechatPay.pay_sign_key,
        package:   package,
        timestamp: timestamp
      )
    end
  end
end
