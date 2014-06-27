require 'digest/md5'

module WechatPay
  module Notify
    def self.verify?(params)
      sign = params.delete(:sign) || params.delete('sign')
      return false if sign.nil? || sign.empty?

      str = params.sort.map { |item| item.join('=') }.join('&')
      str << "&key=#{WechatPay.partner_key}"
      params_sign = Digest::MD5.hexdigest(str).upcase

      params_sign == sign
    end
  end
end
