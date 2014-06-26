require 'digest/sha1'
require 'digest/md5'

module WechatPay
  module Sign
    def self.generate(params)
      str = params.sort.map { |item| item.join('=') }.join('&')
      Digest::SHA1.hexdigest(str)
    end

    def self.package(params)
      str = params.sort.map { |item| item.join('=') }.join('&')
      str << "&key=#{WechatPay.partner_key}"
      Digest::MD5.hexdigest(str).upcase
    end
  end
end
