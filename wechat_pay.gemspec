# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wechat_pay/version'

Gem::Specification.new do |spec|
  spec.name          = "wechat_pay"
  spec.version       = WechatPay::VERSION
  spec.authors       = ["HungYuHei"]
  spec.email         = ["kongruxi@gmail.com"]
  spec.summary       = "微信支付"
  spec.description   = "微信支付"
  spec.homepage      = "https://github.com/HungYuHei/wechat_pay"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.6.7"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fakeweb", "~> 1.3"
end
