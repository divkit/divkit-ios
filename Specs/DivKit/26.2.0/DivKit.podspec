Pod::Spec.new do |s|
  s.name             = 'DivKit'
  s.version          = '26.2.0'
  s.summary          = 'DivKit framework'
  s.description      = 'DivKit is a backend-driven UI framework'
  s.homepage         = 'https://divkit.tech'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'divkit' => 'divkit@yandex-team.ru' }
  s.source           = { :git => 'https://github.com/divkit/divkit-ios.git', :tag => s.version.to_s }

  s.swift_version = '5'
  s.requires_arc = true
  s.prefix_header_file = false
  s.platforms = { :ios => '11.0' }

  s.dependency 'CommonCorePublic', s.version.to_s
  s.dependency 'LayoutKit', s.version.to_s
  s.dependency 'NetworkingPublic', s.version.to_s
  s.dependency 'Serialization', s.version.to_s

  s.source_files = [
    'DivKit/**/*'
  ]
end
