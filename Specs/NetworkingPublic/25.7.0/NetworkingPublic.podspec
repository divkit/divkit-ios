Pod::Spec.new do |s|
  s.name             = 'NetworkingPublic'
  s.version          = '25.7.0'
  s.summary          = 'Part of DivKit framework'
  s.description      = 'Part of DivKit framework'
  s.homepage         = 'https://divkit.tech'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'divkit' => 'divkit@yandex-team.ru' }
  s.source           = { :git => 'https://github.com/divkit/divkit-ios.git', :tag => s.version.to_s }

  s.swift_version = '5'
  s.requires_arc = true
  s.prefix_header_file = false
  s.platforms = { :ios => '11.0' }

  s.dependency 'BasePublic', s.version.to_s

  s.source_files = [
    'Core/NetworkingPublic/**/*'
  ]
end
