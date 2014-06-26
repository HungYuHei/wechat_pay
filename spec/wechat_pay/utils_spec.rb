require 'spec_helper'

describe WechatPay::Utils do
  it ".slice_hash" do
    hash = { allowed: 'allowed', not_allowed: 'not_allowed' }
    data = WechatPay::Utils.slice_hash(hash, :allowed, :other)

    data[:allowed].wont_be_empty
    data[:not_allowed].must_be_nil
  end
end
