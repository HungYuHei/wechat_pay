require 'wechat_pay/js'
require 'wechat_pay/app'
require 'wechat_pay/sign'
require 'wechat_pay/utils'
require 'wechat_pay/notify'
require 'wechat_pay/version'
require 'wechat_pay/package'
require 'wechat_pay/prepay_id'
require 'wechat_pay/access_token'
require 'wechat_pay/deliver_notify'

module WechatPay
  class << self
    attr_accessor :app_id, :app_secret, :pay_sign_key, :partner_id, :partner_key
  end
end
