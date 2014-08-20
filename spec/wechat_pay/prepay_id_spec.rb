require 'spec_helper'

describe WechatPay::PrepayId do
  let(:prepay_id) { 'TEST_PREPAY_ID' }

  before do
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/genprepay.+|,
      body: %Q({"prepayid":"#{prepay_id}","errcode":0,"errmsg":"Success"})
    )
  end

  it ".generate" do
    params = {
      traceid: 'traceid',
      noncestr: 'noncestr',
      package: 'package',
      timestamp: Time.now.to_i.to_s,
    }
    WechatPay::PrepayId.generate('ACCESS_TOKEN', params).must_equal(prepay_id)
  end
end
