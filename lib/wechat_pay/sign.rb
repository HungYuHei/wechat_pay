require 'digest/sha1'

module WechatPay
  module Sign
    def self.generate(params)
      str = params.sort.map { |item| item.join('=') }.join('&')
      Digest::SHA1.hexdigest(str)
    end
  end
end
