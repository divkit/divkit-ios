Pod::Spec.new do |s|
  s.name             = 'DivKit_LayoutKitInterface'
  s.module_name      = 'LayoutKitInterface'
  s.version          = '30.1.0'
  s.summary          = 'Part of DivKit framework'
  s.description      = 'Part of DivKit framework'
  s.homepage         = 'https://divkit.tech'

  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author           = { 'divkit' => 'divkit@yandex-team.ru' }
  s.source           = { :git => 'https://github.com/divkit/divkit-ios.git', :tag => s.version.to_s }

  s.swift_version = '5.9'
  s.requires_arc = true
  s.prefix_header_file = false
  s.platforms = { :ios => '13.0' }

  s.dependency 'VGSLBase', '~> 5.0'
  s.dependency 'VGSLBaseTiny', '~> 5.0'
  s.dependency 'VGSLBaseUI', '~> 5.0'

  s.source_files = [
    'LayoutKit/Interface/**/*'
  ]
end
