require 'spec_helper'

describe WechatPay::Sign do
  it ".generate" do
    params = { appid: 'appid', appkey: 'appkey' }
    WechatPay::Sign.generate(params).wont_be_empty
  end
end
