require 'spec_helper'

describe WechatPay::App do

  it ".payment" do
    prepay_id = "PREPAY_ID"
    prepay_params = {
      traceid:          'traceid',
      body:             'body',
      out_trade_no:     'out_trade_no',
      total_fee:        'total_fee',
      notify_url:       'http://your_domain.com',
      spbill_create_ip: '192.168.1.1'
    }

    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/genprepay.+|,
      body: %Q({"prepayid":"#{prepay_id}","errcode":0,"errmsg":"Success"})
    )

    payment = WechatPay::App.payment('access_token', prepay_params)

    payment[:prepayid].must_equal prepay_id
    payment[:sign].wont_be_empty
  end
end
