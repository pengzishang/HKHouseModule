#
# Be sure to run `pod lib lint HKHouseModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HKHouseModule'
  s.version          = '1.0.0'
  s.summary          = 'A short description of HKHouseModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/pengzishang/HKHouseModule'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pengzishang' => 'deshpeng@gmail.com' }
  # s.source           = { :git => 'https://github.com/pengzishang/HKHouseModule.git', :tag => s.version.to_s }
  s.source           = { :git => "http://git.midland.com.cn/midland-hft-iOS/HKHouseModule.git", :branch => 'temp/temp' , :tag => s.version.to_s }

  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'HKHouseModule/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HKHouseModule' => ['HKHouseModule/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReactiveCocoa'
  s.dependency 'IQKeyboardManager'
  s.dependency 'SDWebImage'
  s.dependency 'MJExtension'
  # 宏定义
  s.dependency 'HFTCommonDefinition'
  # 扩展
  s.dependency 'HFTCategroy'
  s.dependency 'RZColorful'
  # APP生命周期管理
  s.dependency 'HFTModuleCycleManager'
  # 导航栏控制器管理
  s.dependency 'HFTNavigation'
  # Tools
  s.dependency 'HFTMapKit'
  s.dependency 'HFTTools'
  # UI
  s.dependency 'HFTUIKit'
  s.dependency 'HFTHud'
  # 中间件
  s.dependency 'ErpRouter'
  s.dependency 'ErpConditionBar'
  s.dependency 'GlobalDataRefresher'
  # 网络请求
  s.dependency 'ErpNetwork'
  s.dependency 'ErpCommon'
  s.dependency 'ErpRubbish'
  s.dependency 'HFTWebKit'
  # 行为记录
  s.dependency 'HFTTracker'
  s.dependency 'ErpTools'
end
