# WechatPay

微信支付: https://open.weixin.qq.com/cgi-bin/frame?t=home/pay_tmpl&lang=zh_CN

It contains:

* generate access-token
* app payment
* js payment
* native payment
* verify notify
* deliver notify
* order query

MRI Ruby 2.0.0 and newer are supported. 1.9.2 should work as well but not tested.

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
WechatPay::AccessToken.generate # => { access_token: 'ACCESS_TOKEN', expires_in: 7200 }
```

Your should cache the `access_token`, see [http://mp.weixin.qq.com/wiki/index.php...](http://mp.weixin.qq.com/wiki/index.php?title=%E8%8E%B7%E5%8F%96access_token)

You may wanna do something like this in Rails:

```ruby
Rails.cache.fetch(:wechat_pay_access_token, expires_in: 7200.seconds, raw: true) do
  WechatPay::AccessToken.generate[:access_token]
end
```

### App Payment params

```ruby
# Please keep in mind that all key MUST be Symbol
params = {
  body:             'body',
  traceid:          'traceid',      # Your user id
  out_trade_no:     'out_trade_no', # Your order id
  total_fee:        '100',          # 注意：单位是分，不是元
  notify_url:       'http://your_domain.com/notify',
  spbill_create_ip: '192.168.1.1'
}

WechatPay::App.payment('ACCESS_TOKEN', params)
# =>
#   {
#     nonce_str:  'noncestr',
#     package:    'Sign=WXpay',
#     partner_id: 'partner_id',
#     prepay_id:  'prepay_id',
#     timestamp:  '1407165191',
#     sign:       'sign'
#   }
```

### Native Payment params

###### generate url

```ruby
WechatPay::Native.payment('OUT_TRADE_NO')
# => "weixin://wxpay/bizpayurl?sign=SIGN&productid=..."
```

###### verify and generate package

```ruby
# example in rails controller
def package
  request_data = Hash.from_xml(request.body.read)['xml'].symbolize_keys
  app_signature = request_data[:AppSignature]
  verify_params = {
    productid:   request_data[:ProductId],
    timestamp:   request_data[:TimeStamp],
    noncestr:    request_data[:NonceStr],
    openid:      request_data[:OpenId],
    issubscribe: request_data[:IsSubscribe]
  }
  verified = WechatPay::Native.verify?(app_signature, verify_params)

  if verified
    # you may wanna find the order by `request_data['ProductId']`
    package_params = {
      body:             'body',
      out_trade_no:     'out_trade_no',
      total_fee:        '1',
      notify_url:       'http://your_domain.com/wechat_pay/notify',
      spbill_create_ip: request.remote_ip
    }
    @data = WechatPay::Native.package('0', 'ok', package_params)
    render "package.xml.erb"
  else
    render nothing: true
  end
end

# package.xml.erb
<xml>
  <AppId><%= @data[:app_id] %></AppId>
  <NonceStr><%= @data[:nonce_str] %></NonceStr>
  <TimeStamp><%= @data[:timestamp] %></TimeStamp>
  <Package><%= @data[:package] %></Package>
  <RetCode><%= @data[:ret_code] %></RetCode>
  <RetErrMsg><%= @data[:ret_err_msg] %></RetErrMsg>
  <SignMethod><%= @data[:sign_method] %></SignMethod>
  <AppSignature><%= @data[:app_signature] %></AppSignature>
</xml>
```

### JS Payment params

###### In Controller

```ruby
params = {
  body:             'body',
  out_trade_no:     'out_trade_no'
  total_fee:        '100'
  notify_url:       'http://your_domain.com/notify',
  spbill_create_ip: '192.168.1.1'
}

@order_params = WechatPay::JS.payment(params)

# =>
#    {
#      app_id:    "app_id",
#      timestamp: "1407165191",
#      nonce_str: "noncestr",
#      package:   "Sign=WXpay",
#      pay_sign:  "pay_sign",
#      sign_type: 'SHA1'
#    }
```

###### In View (slim)

```ruby
= link_to "wechat_payment_btn", "javascript:void(0)", id: "wechatPaymentBtn"

javascript:
  var orderParams = { 
    appId:     "#{@order_params[:app_id]}",
    timeStamp: "#{@order_params[:timestamp]}",
    nonceStr:  "#{@order_params[:nonce_str]}",
    package:   "#{@order_params[:package]}",
    paySign:   "#{@order_params[:pay_sign]}",
    signType:  "#{@order_params[:sign_type]}"
  };
  document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
    $('#wechatPaymentBtn').click(function(){
      WeixinJSBridge.invoke('getBrandWCPayRequest', orderParams, function(res) {
        if (res.err_msg == "get_brand_wcpay_request:ok") {
          alert('pay for success!');
        } else {
          alert(res.err_msg);
        }
      });
    });
  }, false);
```

### Verify notify

```ruby
# Rails example
def app_notify
  # except :controller_name, :action_name, :host, etc.
  notify_params = params.except(*request.path_parameters.keys)

  if WechatPay::Notify.verify?(notify_params)
    # Valid notify status
    if params[:trade_state] == '0'
      # Code your business logic
    end
    render text: 'success'
  else
    render text: 'error'
  end
end
```

### Deliver Notify

```ruby
# Please keep in mind that all key MUST be Symbol
params = {
  openid: 'openid',
  transid: 'transid',
  out_trade_no: 'out_trade_no',
  deliver_msg: 'ok',              # optional, default is 'ok'
  deliver_status: '1',            # optional, default is '1'
  deliver_timestamp: '1410105134' # optional, default is `Time.now.to_i.to_s`
}

WechatPay::DeliverNotify.request('ACCESS_TOKEN', params)
# => { errcode: 0, errmsg: 'ok' }
```

### Order Query

```ruby
WechatPay::OrderQuery.request('ACCESS_TOKEN', 'YOUR_OUT_TRADE_NO')
# => { errcode: 0, errmsg: 'ok', order_info: { ret_code: 0, ... } }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

[WTFPL](http://wtfpl.org)
