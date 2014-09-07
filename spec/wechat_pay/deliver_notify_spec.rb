require 'spec_helper'

describe WechatPay::DeliverNotify do
  before do
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/delivernotify.+|,
      body: %Q({"errcode":0,"errmsg":"ok"})
    )
  end

  it ".request" do
    params = {
      openid: 'openid',
      transid: 'transid',
      out_trade_no: 'out_trade_no'
    }

    response = WechatPay::DeliverNotify.request('ACCESS_TOKEN', params)
    response[:errcode].must_equal 0
    response[:errmsg].must_equal 'ok'
  end
end
