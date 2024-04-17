Pod::Spec.new do |s|
  s.name         = "Orkestapay"
  s.version      = "0.0.1"
  s.summary      = "Orkestapay iOS library"
  s.homepage     = "https://orkestapay.com"
  s.license      = "MIT"
  s.author       = { "Hector Rodriguez" => "https://orkestapay.com" }
  s.source       = { :git => "https://github.com/orkestapay/orkestapay-ios.git", :tag => "#{s.version}" }
  s.platform = :ios
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.7'
  s.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {
    'Orkestapay_Privacy' => ['Sources/PrivacyInfo.xcprivacy'],
  }
end
