require 'digest/md5'

module WechatPay
  module Notify
    def self.verify?(params)
      sign = params.delete(:sign) || params.delete('sign')
      !!sign && sign == Sign.md5(params)
    end
  end
end
