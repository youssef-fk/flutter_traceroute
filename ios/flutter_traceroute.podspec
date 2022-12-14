#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_traceroute.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_traceroute'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  # s.source           = {
  #   :git => "https://github.com/IGRSoft/SimpleTracer.git",
  #   :tag => "0.1.1" 
  # }
  s.source_files = 'Classes/**/*'
#  s.source_files = 'SimpleTracer/**/*'
  s.dependency 'Flutter'
  
  s.dependency 'SimpleTracer'
  s.platform = :ios, '14.0'
  
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  
  s.requires_arc     = true
  s.static_framework = true
end
