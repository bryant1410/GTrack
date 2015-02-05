Pod::Spec.new do |s|

  s.name                = "GTrack"
  s.version             = "0.9"
  s.summary             = "GTrack is a lightweight Objective-C wrapper around the Google Analytics for iOS SDK with some extra goodies, brought to you by Gemr."
  s.homepage            = "https://github.com/gemr/GTrack"
  s.license             = "MIT"
  s.author              = { "Mike Amaral" => "mike.amaral36@gmail.com" }
  s.social_media_url    = "http://twitter.com/MikeAmaral"
  s.platform            = :ios
  s.ios.deployment_target = "7.1"
  s.source              = { :git => "https://github.com/gemr/GTrack.git", :tag => "v0.9" }
  s.source_files        = "GTrack/Source/GTTracker.{h,m}"
  s.dependency		"GoogleAnalytics-iOS-SDK"
  s.requires_arc        = true

end
