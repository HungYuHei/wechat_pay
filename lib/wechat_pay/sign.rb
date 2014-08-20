require 'digest/sha1'

module WechatPay
  module Sign
    def self.sha1(params)
      str = params.sort.map { |item| item.join('=') }.join('&')
      Digest::SHA1.hexdigest(str)
    end

    def self.md5(params)
      str = params.sort.map { |item| item.join('=') }.join('&')
      str << "&key=#{WechatPay.partner_key}"
      Digest::MD5.hexdigest(str).upcase
    end
  end
end
