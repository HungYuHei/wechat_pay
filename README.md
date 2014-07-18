# WechatPay

Wechat Pay: https://open.weixin.qq.com

It contains:

* generate access_token
* generate payment params

## Installation

Add this line to your application's Gemfile:

    gem 'wechat_pay'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wechat_pay

## Usage

### Config

```ruby
WechatPay.app_id       = 'YOUR_APP_ID'
WechatPay.app_secret   = 'YOUR_APP_SECRET'
WechatPay.pay_sign_key = 'YOUR_PAY_SIGN_KEY'
WechatPay.partner_id   = 'YOUR_PARTNER_ID'
WechatPay.partner_key  = 'YOUR_PARTNER_KEY'

```

### Access Token

```ruby
WechatPay::AccessToken.generate # => { "access_token" => ACCESS_TOKEN, "expires_in" => 7200 }
```

Your should cache the access_token, see http://mp.weixin.qq.com/wiki/index.php?title=%E8%8E%B7%E5%8F%96access_token

### Payment params

```ruby
params = {
  traceid:          'traceid',
  body:             'body',
  out_trade_no:     'out_trade_no',
  total_fee:        'total_fee',
  notify_url:       'http://your_domain.com',
  spbill_create_ip: '192.168.1.1'
}

# it will automatically generate prepay_id for you.
WechatPay::App.payment('ACCESS_TOKEN', params)
# =>
#   {
#     prepay_id: 'PREPAY_ID',
#     pay_sign: 'PAY_SIGN'
#   }
```

Once you get the payment params, ...

## Contributing

1. Fork it ( https://github.com/[my-github-username]/wechat_pay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
