Pod::Spec.new do |s|
s.name             = 'RyanUI'
s.version          = '0.0.2'
s.summary          = 'Custom pod creation for iOS'
s.description      = <<-DESC “Ryan's UI Repository'”
This is a repository that holds all Ryan UI elements and lets him import them to wherever he so desires.
DESC

s.homepage         = 'https://github.com/helgeryan/ryanUI'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'username' => 'ryanhelgeson14@gmail.com' }
s.source           = { :git => 'git@github.com:helgeryan/ryanUI.git', :tag => s.version.to_s }
s.ios.deployment_target = '10.0'
s.source_files = 'Source/*'  //point the source file to which files you want to commit//
end
