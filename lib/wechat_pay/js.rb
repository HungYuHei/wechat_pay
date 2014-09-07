module WechatPay
  module JS
    def self.payment(params)
      sign_attrs = {
        package:   Package.generate(params),
        appid:     WechatPay.app_id,
        appkey:    WechatPay.pay_sign_key,
        noncestr:  SecureRandom.hex(16),
        timestamp: Time.now.to_i.to_s
      }
      pay_sign = Sign.sha1(sign_attrs)

      {
        app_id:    sign_attrs[:appid],
        timestamp: sign_attrs[:timestamp],
        nonce_str: sign_attrs[:noncestr],
        package:   sign_attrs[:package],
        pay_sign:  pay_sign,
        sign_type: 'SHA1'
      }
    end
  end
end
