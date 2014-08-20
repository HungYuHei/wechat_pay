require 'spec_helper'

describe WechatPay::Package do
  it ".generate" do
    params = {
      body: 'body',
      out_trade_no: 'out_trade_no',
      total_fee: '1',
      notify_url: 'http://test.com',
      spbill_create_ip: '127.0.0.1'
    }

    WechatPay::Package::App.generate(params).must_include '&sign='
  end
end
