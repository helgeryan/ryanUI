Pod::Spec.new do |s|
s.name             = 'RyanUI'
s.version          = '0.0.5'
s.summary          = 'Custom pod creation for iOS'
s.homepage         = 'https://github.com/helgeryan/ryanUI'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'username' => 'ryanhelgeson14@gmail.com' }
s.source           = { :git => 'git@github.com:helgeryan/ryanUI.git', :tag => s.version.to_s }
s.ios.deployment_target = '10.0'
s.source_files = 'Source/RyanUI/Sources/**/*.swift'
s.frameworks = 'UIKit'
s.module_name = 'RyanUI'
end
