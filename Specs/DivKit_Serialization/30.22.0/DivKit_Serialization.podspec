Pod::Spec.new do |s|
  s.name             = 'DivKit_Serialization'
  s.module_name      = 'Serialization'
  s.version          = '30.22.0'
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

  s.dependency 'VGSL', '~> 6.0'

  s.source_files = [
    'Serialization/**/*'
  ]
end
