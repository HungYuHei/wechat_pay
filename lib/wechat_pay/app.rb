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
      package = generate_package(params)

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

    private

    PACKAGE_PARAMS = [
      :bank_type, :body, :attach, :partner, :out_trade_no, :total_fee, :fee_type,
      :notify_url, :spbill_create_ip, :time_start, :time_expire, :transport_fee,
      :product_fee, :goods_tag, :input_charset
    ]

    def self.generate_package(package_params)
      package_params = Utils.slice_hash(package_params, *PACKAGE_PARAMS)

      params = {
        bank_type: 'WX',
        fee_type: '1',
        input_charset: 'UTF-8',
        partner: WechatPay.partner_id
      }.merge(package_params)

      regexp = Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
      escaped_params_str = params.sort.map do |key, value|
        "#{key}=#{URI.escape(value.to_s, regexp)}"
      end.join('&')

      "#{escaped_params_str}&sign=#{Sign.md5(params)}"
    end

  end
end
