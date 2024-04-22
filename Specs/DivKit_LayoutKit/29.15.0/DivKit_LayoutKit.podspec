Pod::Spec.new do |s|
  s.name             = 'DivKit_LayoutKit'
  s.module_name      = 'LayoutKit'
  s.version          = '29.15.0'
  s.summary          = 'Part of DivKit framework'
  s.description      = 'Part of DivKit framework'
  s.homepage         = 'https://divkit.tech'

  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'divkit' => 'divkit@yandex-team.ru' }
  s.source           = { :git => 'https://github.com/divkit/divkit-ios.git', :tag => s.version.to_s }

  s.swift_version = '5.9'
  s.requires_arc = true
  s.prefix_header_file = false
  s.platforms = { :ios => '11.0' }
  
  s.dependency 'DivKit_LayoutKitInterface', s.version.to_s
  s.dependency 'VGSLCommonCore', '~> 4.1'
  s.dependency 'VGSLNetworking', '~> 4.1'

  s.source_files = [
    'LayoutKit/LayoutKit/**/*'
  ]
end
