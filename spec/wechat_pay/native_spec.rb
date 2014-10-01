require 'spec_helper'

describe WechatPay::Native do
  it ".payment" do
    product_id = 'test_product_id'
    url = WechatPay::Native.payment(product_id)
    url.must_include 'weixin://wxpay/bizpayurl?'
    url.must_include product_id
  end
end
