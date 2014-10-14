module WechatPay
  module Notify
    def self.verify?(params)
      sign = params.delete(:sign) || params.delete('sign')
      !!sign && sign == Sign.md5_with_partner_key(params)
    end

    module Warning
      def self.verify?(app_signature, params)
        attrs = {
          appid: WechatPay.app_id,
          appkey: WechatPay.pay_sign_key
        }.merge(params)

        app_signature == Sign.sha1(attrs)
      end
    end
  end
end
