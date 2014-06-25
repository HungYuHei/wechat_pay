require 'spec_helper'

describe WechatPay::App do
  before do
    @options = {
      traceid: 'traceid',
      noncestr: 'noncestr',
      timestamp: 'timestamp',
      body: 'body',
      out_trade_no: 'out_trade_no',
      total_fee: 'total_fee',
      notify_url: 'notify_url',
      spbill_create_ip: 'spbill_create_ip'
    }
    @prepay_id = "PREPAY_ID"
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/genprepay.+|,
      body: %Q({"prepayid":"#{@prepay_id}","errcode":0,"errmsg":"Success"})
    )
  end

  it ".prepay_id" do
    WechatPay::App.prepay_id('access_token', @options).must_equal @prepay_id
  end
end
