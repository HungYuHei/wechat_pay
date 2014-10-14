require 'spec_helper'

describe WechatPay::Notify do
  describe ".verify?" do
    it "with nil sign" do
      WechatPay::Notify.verify?({}).must_equal(false)
    end

    it "success" do
      params = {b: 'b', a: 'a'}
      str = params.sort.map { |i| i.join('=') }.join('&')
      str << "&key=#{WechatPay.partner_key}"
      sign = Digest::MD5.hexdigest(str).upcase

      WechatPay::Notify.verify?(params.merge(sign: sign)).must_equal(true)
    end
  end

  it "Warning.verify?" do
    app_signature = 'incorrect_app_signature'
    params = {
      appid: 'appid',
      alarmcontent: 'alarmcontent',
      description: 'description',
      errortype: 'errortype',
      timestamp: Time.now.to_i.to_s
    }
    result = WechatPay::Notify::Warning.verify?(app_signature, params)
    result.must_equal(false)
  end
end
