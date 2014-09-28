require 'spec_helper'

describe WechatPay::OrderQuery do
  before do
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/orderquery.+|,
      body: %Q({"errcode":0,"errmsg":"ok","order_info":{"ret_code":0}})
    )
  end

  it ".request" do
    response = WechatPay::OrderQuery.request('ACCESS_TOKEN', 'OUT_TRADE_NO')
    response[:errcode].must_equal 0
    response[:errmsg].must_equal 'ok'
    response[:order_info].wont_be_nil
  end
end
