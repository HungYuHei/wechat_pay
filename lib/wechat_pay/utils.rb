module WechatPay
  module Utils
    def self.slice_hash(hash, *keys)
      keys.each_with_object({}) { |k, h| h[k] = hash[k] if hash.has_key?(k) }
    end
  end
end
