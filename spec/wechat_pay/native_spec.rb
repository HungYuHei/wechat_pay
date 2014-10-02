require 'spec_helper'

describe WechatPay::Native do
  it ".payment" do
    product_id = 'test_product_id'
    url = WechatPay::Native.payment(product_id)
    url.must_include 'weixin://wxpay/bizpayurl?'
    url.must_include product_id
  end

  it ".verify?" do
    params = {
      productid: 'productid',
      timestamp: 'timestamp',
      noncestr: 'noncestr',
      openid: 'openid',
      issubscribe: '1'
    }

    result = WechatPay::Native.verify?('app_signature', params)
    result.must_equal(false)
  end

  it ".package" do
    params = {
      body:             'body',
      out_trade_no:     'out_trade_no',
      total_fee:        '2',
      notify_url:       'http://your_domain.com/notify',
      spbill_create_ip: '192.168.1.1'
    }
    data = WechatPay::Native.package('0', 'ok', params)

    data[:package].wont_be_nil
    data[:app_signature].wont_be_nil
    data[:ret_code].wont_be_nil
    data[:ret_err_msg].wont_be_nil
  end
end
