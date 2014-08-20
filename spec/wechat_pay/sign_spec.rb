require 'spec_helper'

describe WechatPay::Sign do
  it ".sha1" do
    params = { appid: 'appid', appkey: 'appkey' }
    WechatPay::Sign.sha1(params).wont_be_empty
  end
end
