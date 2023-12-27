#
# Be sure to run `pod lib lint CmgeSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CmgeSDK'
  s.version          = '1.21.0'
  s.summary          = 'A short description of CmgeSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WakeyWoo/CmgeSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'WakeyWoo' => 'hjw728uow@gmail.com' }
  s.source           = { :git => 'https://github.com/WakeyWoo/CmgeSDK.git', :tag => s.version.to_s }
  #s.ios.deployment_target = "9.0"
  s.libraries        = 'sqlite3'
  s.requires_arc  = true
  #s.default_subspecs = 'CmgeCore'
  s.platform     = :ios, "9.0"
  s.dependency 'JtlyAnalyticsSDK','= 1.5.1'
  # s.social_media_url = 'https://twitter.com/WakeyWoo'
  
  #s.default_subspec = 'CmgeStandardKit'
  s.pod_target_xcconfig = {
    'VALID_ARCHS' => 'arm64'
  }
  
  s.subspec 'CmgeCore' do |c|
    c.ios.deployment_target = '9.0'
    #c.public_header_files = 'CmgeSDK/Frameworks/includes/*.h'
    c.vendored_frameworks = 'CmgeSDK/Frameworks/CmgeCore/CmgeStandardKit.xcframework', 'CmgeSDK/Frameworks/CmgeCore/CmgeDeviceInfoKit.xcframework', 'CmgeSDK/Frameworks/CmgeCore/CmgeIdentifierKit.xcframework', 'CmgeSDK/Frameworks/CmgeCore/CmgeShareKit.xcframework'
   
    #c.source_files = 'CmgeSDK/Frameworks/CmgeStandardKit.xcframework/**/*.{c,h}'
    #c.exclude_files = 'CmgeSDK/Frameworks/CmgeStandardKit.xcframework/**/Headers/*.h'
  
    c.ios.pod_target_xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC'
    }
    
    #'LD_RUNPATH_SEARCH_PATHS' => ['/usr/lib/swift', '@executable_path/Frameworks']
    #c.source_files = 'Sources/Producer/**/*.{h,m}', 'Sources/aliyun-log-c-sdk/**/*.{c,h}'
    
  end
  
  s.subspec 'AliyunLog' do |c|
    c.ios.deployment_target = '9.0'
    c.vendored_frameworks = 'CmgeSDK/Frameworks/AliyunLog/AliNetworkDiagnosis.xcframework', 'CmgeSDK/Frameworks/AliyunLog/AliyunLogCore.xcframework', 'CmgeSDK/Frameworks/AliyunLog/AliyunLogCrashReporter.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogNetworkDiagnosis.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogOT.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogOTSwift.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogProducer.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogTrace.xcframework','CmgeSDK/Frameworks/AliyunLog/AliyunLogURLSession.xcframework','CmgeSDK/Frameworks/AliyunLog/WPKMobi.xcframework'
    #c.libraries = "libresolv.tbd"
    c.resources = 'CmgeSDK/Frameworks/AliyunLog/JtlyAliyunLog.txt'
    c.ios.frameworks = "SystemConfiguration", "CoreGraphics"
    c.libraries = "z", "c++", "resolv"
    #c.exclude_files = 'CmgeSDK/Frameworks/JtlyAnalyticsKit.xcframework/**/Headers/*.h'
    #c.source_files = 'Sources/Producer/**/*.{h,m}', 'Sources/aliyun-log-c-sdk/**/*.{c,h}'
    #c.public_header_files = 'CmgeSDK/Frameworks/JtlyAnalyticsKit.xcframework/**/Headers/*.h'
    c.ios.pod_target_xcconfig = {
        'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
        'OTHER_LDFLAGS' => '-ObjC'
    }
    
    c.user_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    
    c.xcconfig = {
      'LIBRARY_SEARCH_PATHS' => ['"$(SDKROOT)/usr/lib/swift"', '"$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)"'],
      'LD_RUNPATH_SEARCH_PATHS' => ['/usr/lib/swift', '"@executable_path/Frameworks"']
    }
    
  end
  
  s.subspec 'AliAuth' do |c|
    c.ios.deployment_target = '9.0'
    c.vendored_frameworks = 'CmgeSDK/Frameworks/AliAuth/ATAuthSDK.framework', 'CmgeSDK/Frameworks/AliAuth/YTXMonitor.framework', 'CmgeSDK/Frameworks/AliAuth/YTXOperators.framework'
    c.ios.pod_target_xcconfig = {
        'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    
    c.user_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
  end

  
end
