module WechatPay
  module Notify
    def self.verify?(params)
      sign = params.delete(:sign) || params.delete('sign')
      !!sign && sign == Sign.md5_with_partner_key(params)
    end
  end
end
