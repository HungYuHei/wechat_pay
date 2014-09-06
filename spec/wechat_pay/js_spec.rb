require 'spec_helper'

describe WechatPay::JS do
  it ".payment" do
    params = {
      body:             'body',
      out_trade_no:     'out_trade_no',
      total_fee:        '2',
      notify_url:       'http://your_domain.com/notify',
      spbill_create_ip: '192.168.1.1'
    }

    package = WechatPay::Package::App.generate(params)
    payment = WechatPay::JS.payment(params)

    payment[:app_id].must_equal WechatPay.app_id
    payment[:package].must_equal package
    payment[:timestamp].wont_be_empty
    payment[:nonce_str].wont_be_empty
    payment[:pay_sign].wont_be_empty
    payment[:sign_type].must_equal 'SHA1'
  end
end
