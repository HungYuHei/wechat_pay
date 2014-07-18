require 'uri'
require 'json'
require 'rest_client'
require 'securerandom'

module WechatPay
  module App

    # required params:
    #   traceid, body, out_trade_no, total_fee, notify_url, spbill_create_ip
    def self.payment(access_token, params)
      noncestr = SecureRandom.hex(16)
      timestamp = Time.now.to_i.to_s
      package = generate_package(params)

      app_signature = generate_app_signature(
        noncestr:  noncestr,
        timestamp: timestamp,
        package:   package,
        traceid:   params[:traceid],
      )

      prepay_id = generate_prepay_id(
        access_token,
        traceid:       params[:traceid],
        noncestr:      noncestr,
        package:       package,
        timestamp:     timestamp,
        app_signature: app_signature
      )

      params = {
        appid:     WechatPay.app_id,
        appkey:    WechatPay.pay_sign_key,
        noncestr:  noncestr,
        package:   'Sign=WXpay',
        partnerid: WechatPay.partner_id,
        prepayid:  prepay_id,
        timestamp: timestamp
      }

      sign = Sign.generate(params)
      params.merge(sign: sign)
    end

    private

    def self.generate_prepay_id(access_token, params)
      url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"

      params = {
        appid:         WechatPay.app_id,
        traceid:       params[:traceid],
        noncestr:      params[:noncestr],
        package:       params[:package],
        timestamp:     params[:timestamp],
        app_signature: params[:app_signature],
        sign_method:   'sha1'
      }

      RestClient.post(url, JSON.generate(params)) do |response|
        JSON.parse(response.body)['prepayid']
      end
    end

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

      "#{escaped_params_str}&sign=#{Sign.package(params)}"
    end

    def self.generate_app_signature(signature_params)
      params = {
        appid: WechatPay.app_id,
        appkey: WechatPay.pay_sign_key,
        noncestr: signature_params[:noncestr],
        package: signature_params[:package],
        timestamp: signature_params[:timestamp],
        traceid: signature_params[:traceid]
      }

      Sign.generate(params)
    end
  end
end
