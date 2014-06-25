require 'spec_helper'

describe WechatPay::AccessToken do
  before do
    @access_token = "ACCESS_TOKEN"
    FakeWeb.register_uri(:get,
                         %r|https://api\.weixin\.qq\.com/cgi-bin/token.+|,
                         body: %Q({"access_token":"#{@access_token}","expires_in":7200}))
  end

  it ".generate" do
    WechatPay::AccessToken.generate['access_token'].must_equal @access_token
  end
end
