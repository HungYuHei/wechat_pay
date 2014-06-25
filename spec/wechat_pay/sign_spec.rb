require 'spec_helper'

describe WechatPay::Sign do
  it ".generate" do
    params = { a: 'a', b: 'b' }
    WechatPay::Sign.generate(params).wont_be_empty
  end
end
