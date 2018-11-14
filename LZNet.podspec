#
# Be sure to run `pod lib lint LZNet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LZNet'
  s.version          = '1.0.1'
  s.summary          = 'A custom network framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/superleezen/LZNet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'emailoflizheng@126.com' => 'leezen' }
  s.source           = { :git => 'https://github.com/superleezen/LZNet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LZNet/*.{h,m}'
  
    s.subspec 'Result' do |result|
        result.source_files = 'LZNet/Result/*.{h,m}'
    end

    s.subspec 'HUD' do |hud|
        hud.source_files = 'LZNet/HUD/*.{h,m}'
    end

    s.subspec 'Handler' do |handler|
        handler.source_files = 'LZNet/Handler/*.{h,m}'
    end

    s.subspec 'Request' do |reqeust|
        reqeust.dependency 'LZNet/HUD'
        reqeust.dependency 'LZNet/Result'
        reqeust.dependency 'LZNet/Handler'
        reqeust.source_files = 'LZNet/Request/*.{h,m}'
    end
  # s.resource_bundles = {
  #   'LZNet' => ['LZNet/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '3.1.0'
end
