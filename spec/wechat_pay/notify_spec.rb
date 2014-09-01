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
end
