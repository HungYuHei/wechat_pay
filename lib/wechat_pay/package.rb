module WechatPay
  module Package
    PACKAGE_PARAMS = [
      :bank_type, :body, :attach, :partner, :out_trade_no, :total_fee, :fee_type,
      :notify_url, :spbill_create_ip, :time_start, :time_expire, :transport_fee,
      :product_fee, :goods_tag, :input_charset
    ]

    def self.generate(package_params)
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

      "#{escaped_params_str}&sign=#{Sign.md5_with_partner_key(params)}"
    end
  end
end
