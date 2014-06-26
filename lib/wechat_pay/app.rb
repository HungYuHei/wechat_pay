require 'uri'
require 'json'
require 'rest_client'
require 'digest/md5'
require 'securerandom'

module WechatPay
  module App

    # TODO should we check the required params?
    def self.payment(access_token, params)
      noncestr = SecureRandom.hex(16)
      timestamp = Time.now.to_i.to_s
      prepay_id = generate_prepay_id(access_token, params)

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

    PREPAY_PARAMS = [
      :appid, :traceid, :noncestr, :package, :timestamp, :app_signature, :sign_method
    ]

    def self.generate_prepay_id(access_token, params)
      url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"

      params = {
        appid:         WechatPay.app_id,
        package:       generate_package(params),
        app_signature: generate_app_signature(params),
        sign_method:   'sha1'
      }.merge(params)
      params = Utils.slice_hash(params, *PREPAY_PARAMS)

      RestClient.post(url, params) do |response|
        JSON.parse(response.body)["prepayid"]
      end
    end

    PACKAGE_PARAMS = [
      :bank_type, :body, :attach, :partner, :out_trade_no, :total_fee, :fee_type,
      :notify_url, :spbill_create_ip, :time_start, :time_expire, :transport_fee,
      :product_fee, :goods_tag, :input_charset
    ]

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

      params = Utils.slice_hash(params, *PACKAGE_PARAMS)
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

    APP_SIGNATURE_PARAMS = [
      :appid, :appkey, :noncestr, :package, :timestamp, :traceid
    ]

    def self.generate_app_signature(signature_params)
      params = {
        appid: WechatPay.app_id,
        appkey: WechatPay.pay_sign_key
      }.merge(signature_params)

      Sign.generate(Utils.slice_hash(params, *APP_SIGNATURE_PARAMS))
    end
  end
end
