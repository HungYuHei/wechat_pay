require 'wechat_pay/version'
require 'wechat_pay/access_token'

module WechatPay
  class << self
    attr_accessor :app_id
    attr_accessor :app_secret
  end
end
