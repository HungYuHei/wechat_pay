module WechatPay
  module Native
    def self.payment_url(product_id)
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

    def self.verify?(app_signature, params)
      attrs = {
        appid: WechatPay.app_id,
        appkey: WechatPay.pay_sign_key
      }.merge(params)

      app_signature == Sign.sha1(attrs)
    end

    def self.package(ret_code, ret_err_msg, package_params)
      package = Package.generate(package_params)

      sign_attrs = {
        appid: WechatPay.app_id,
        appkey: WechatPay.pay_sign_key,
        noncestr: SecureRandom.hex(16),
        timestamp: Time.now.to_i.to_s,
        package: package,
        retcode: ret_code,
        reterrmsg: ret_err_msg
      }
      app_signature = Sign.sha1(sign_attrs)

      {
        app_id: sign_attrs[:appid],
        nonce_str: sign_attrs[:noncestr],
        timestamp: sign_attrs[:timestamp],
        package: package,
        ret_code: ret_code,
        ret_err_msg: ret_err_msg,
        sign_method: 'sha1',
        app_signature: app_signature
      }
    end
  end
end
