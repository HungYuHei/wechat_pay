require 'spec_helper'

describe WechatPay::Notify do
  describe ".verify?" do
    it "with nil sign" do
      WechatPay::Notify.verify?({}).must_equal(false)
    end
  end
end
