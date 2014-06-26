require 'uri'
require 'json'
require 'rest_client'
require 'digest/md5'
require 'securerandom'

module WechatPay
  module App

    # prepay_params:
    #   traceid, body, out_trade_no, total_fee, notify_url, spbill_create_ip
    def self.payment(access_token, prepay_params)
      noncestr = SecureRandom.hex(16)
      timestamp = Time.now.to_i.to_s
      prepay_id = generate_prepay_id(access_token, prepay_params)

      params = {
        appid:     WechatPay.app_id,
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

    # :traceid, :noncestr, :timestamp
    # :body, :out_trade_no, :total_fee, :notify_url, :spbill_create_ip for package
    # :traceid, :noncestr, :timestamp for app_signature
    def self.generate_prepay_id(access_token, prepay_params)
      package = generate_package(
        body:             prepay_params.delete(:body),
        out_trade_no:     prepay_params.delete(:out_trade_no),
        total_fee:        prepay_params.delete(:total_fee),
        notify_url:       prepay_params.delete(:notify_url),
        spbill_create_ip: prepay_params.delete(:spbill_create_ip)
      )

      app_signature = generate_app_signature(
        traceid:   prepay_params[:traceid],
        noncestr:  prepay_params[:noncestr],
        timestamp: prepay_params[:timestamp],
        package:   package
      )

      url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"

      params = {
        appid:         WechatPay.app_id,
        package:       package,
        app_signature: app_signature,
        sign_method:   'sha1'
      }.merge(prepay_params)

      RestClient.post(url, params) do |response|
        JSON.parse(response.body)["prepayid"]
      end
    end

    # :body, :out_trade_no, :total_fee, :notify_url, :spbill_create_ip
    def self.generate_package(package_params)
      params = {
        bank_type: 'WX',
        body: package_params[:body],
        partner: WechatPay.partner_id,
        out_trade_no: package_params[:out_trade_no],
        total_fee: package_params[:total_fee],
        fee_type: '1',
        notify_url: package_params[:notify_url],
        spbill_create_ip: package_params[:spbill_create_ip],
        input_charset: 'UTF-8'
      }.merge(package_params)

      sorted_params = params.sort

      str = sorted_params.map do |item|
        item.join('=')
      end.join('&') << "&key=#{WechatPay.partner_key}"

      sign = Digest::MD5.hexdigest(str).upcase

      escaped_params_str = sorted_params.map do |key, value|
        "#{key}=#{URI.escape(value)}"
      end.join('&')

      "#{escaped_params_str}&sign=#{sign}"
    end

    # :noncestr, :package, :timestamp, :traceid
    def self.generate_app_signature(signature_params)
      params = {
        appid: WechatPay.app_id,
        appkey: WechatPay.pay_sign_key
      }.merge(signature_params)

      Sign.generate(params)
    end
  end
end
