require 'uri'
require 'json'
require 'rest_client'
require 'digest/md5'
require 'digest/sha1'

module WechatPay
  module App

    # :traceid, :noncestr, :timestamp
    # :body, :out_trade_no, :total_fee, :notify_url, :spbill_create_ip for package
    # :traceid, :noncestr, :timestamp for app_signature
    def self.prepay_id(access_token, prepay_id_params)
      package = generate_package(
        body:             prepay_id_params.delete(:body),
        out_trade_no:     prepay_id_params.delete(:out_trade_no),
        total_fee:        prepay_id_params.delete(:total_fee),
        notify_url:       prepay_id_params.delete(:notify_url),
        spbill_create_ip: prepay_id_params.delete(:spbill_create_ip)
      )

      app_signature = generate_app_signature(
        traceid:   prepay_id_params[:traceid],
        noncestr:  prepay_id_params[:noncestr],
        timestamp: prepay_id_params[:timestamp],
        package:   package
      )

      url = "https://api.weixin.qq.com/pay/genprepay?access_token=#{access_token}"

      params = {
        appid:         WechatPay.app_id,
        package:       package,
        app_signature: app_signature,
        sign_method:   'sha1'
      }.merge(prepay_id_params)

      RestClient.post(url, params) do |response|
        JSON.parse(response.body)["prepayid"]
      end
    end

    private

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

      str = signature_params.sort.map { |item| item.join('=') }.join('&')
      Digest::SHA1.hexdigest(str)
    end
  end
end
