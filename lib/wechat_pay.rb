require 'wechat_pay/version'
require 'wechat_pay/access_token'
require 'wechat_pay/app'

module WechatPay
  class << self
    attr_accessor :app_id
    attr_accessor :app_secret
    attr_accessor :pay_sign_key
    attr_accessor :partner_id
    attr_accessor :partner_key
  end
end
