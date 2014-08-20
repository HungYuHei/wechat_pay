require 'spec_helper'

describe WechatPay::App do
  let(:prepay_id) { 'TEST_PREPAY_ID' }

  before do
    FakeWeb.register_uri(
      :post,
      %r|https://api\.weixin\.qq\.com/pay/genprepay.+|,
      body: %Q({"prepayid":"#{prepay_id}","errcode":0,"errmsg":"Success"})
    )
  end

  it ".payment" do
    params = {
      traceid:          'traceid',
      body:             'body',
      out_trade_no:     'out_trade_no',
      total_fee:        '2',
      notify_url:       'http://your_domain.com/notify',
      spbill_create_ip: '192.168.1.1'
    }

    payment = WechatPay::App.payment('access_token', params)

    payment[:partner_id].must_equal WechatPay.partner_id
    payment[:nonce_str].wont_be_empty
    payment[:package].wont_be_empty
    payment[:prepay_id].must_equal prepay_id
    payment[:timestamp].wont_be_empty
    payment[:sign].wont_be_empty
  end
end
