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
        appId:    sign_attrs[:appid],
        timeStamp: sign_attrs[:timestamp],
        nonceStr: sign_attrs[:noncestr],
        package:   sign_attrs[:package],
        paySign:  pay_sign,
        signType: 'SHA1'
      }
    end
  end
end
