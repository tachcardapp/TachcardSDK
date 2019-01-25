#
#  Be sure to run `pod spec lint TachcardSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TachcardSDK"
  s.version      = "0.0.27"
  s.summary      = "just test project"

  s.description  = <<-DESC
  description of empty test project
                   DESC

  s.homepage     = "https://github.com/tachcardapp/TachcardSDK"

  s.license      = "MIT"

  s.author             = { "nightfire_07" => "evgen.garkavenko@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/tachcardapp/TachcardSDK.git", :tag => "#{s.version}" }

  s.resources = "Resources/*"

  s.vendored_frameworks = "Frameworks/TachcardSDK.framework"

  s.dependency "AFNetworking"
  s.dependency "UIDevice-Hardware"
  s.dependency "libextobjc"

end
