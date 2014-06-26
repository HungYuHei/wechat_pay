require 'spec_helper'

describe WechatPay::App do
  before do
    @prepay_id = "PREPAY_ID"
  end

  it ".prepay_id" do
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/genprepay.+|,
      body: %Q({"prepayid":"#{@prepay_id}","errcode":0,"errmsg":"Success"})
    )
    params = {
      traceid: 'traceid',
      noncestr: 'noncestr',
      timestamp: 'timestamp',
      body: 'body',
      out_trade_no: 'out_trade_no',
      total_fee: 'total_fee',
      notify_url: 'notify_url',
      spbill_create_ip: 'spbill_create_ip'
    }
    WechatPay::App.prepay_id('access_token', params).must_equal @prepay_id
  end

  it ".payment" do
    params = {
      noncestr: 'noncestr',
      timestamp: Time.now.to_i.to_s
    }
    WechatPay::App.payment(@prepay_id, params)[:sign].wont_be_empty
  end
end
