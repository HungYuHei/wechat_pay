module WechatPay
  module Native
    def self.payment(product_id)
      attrs = {
        appid:     WechatPay.app_id,
        appkey:    WechatPay.pay_sign_key,
        noncestr:  SecureRandom.hex(16),
        productid: product_id,
        timestamp: Time.now.to_i.to_s
      }
      sign = Sign.sha1(attrs)

      "weixin://wxpay/bizpayurl?sign=#{sign}&appid=#{attrs[:appid]}&productid=#{attrs[:productid]}&timestamp=#{attrs[:timestamp]}&noncestr=#{attrs[:noncestr]}"
    end
  end
end
