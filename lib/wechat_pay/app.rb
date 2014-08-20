require 'uri'
require 'json'
require 'rest_client'
require 'securerandom'
require 'digest/md5'

module WechatPay
  module App

    # required params:
    #   traceid, body, out_trade_no, total_fee, notify_url, spbill_create_ip
    def self.payment(access_token, params)
      noncestr = SecureRandom.hex(16)
      timestamp = Time.now.to_i.to_s
      package = Package.generate(params)

      prepay_id = PrepayId.generate(
        access_token,
        traceid:   params[:traceid],
        noncestr:  noncestr,
        package:   package,
        timestamp: timestamp
      )

      attrs = {
        appid:     WechatPay.app_id,
        appkey:    WechatPay.pay_sign_key,
        noncestr:  noncestr,
        package:   'Sign=WXpay',
        partnerid: WechatPay.partner_id,
        prepayid:  prepay_id,
        timestamp: timestamp
      }
      sign = Sign.sha1(attrs)

      {
        sign:       sign,
        package:    attrs[:package],
        nonce_str:  attrs[:noncestr],
        prepay_id:  attrs[:prepayid],
        timestamp:  attrs[:timestamp],
        partner_id: attrs[:partnerid]
      }
    end

  end
end
