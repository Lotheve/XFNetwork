#
#  Be sure to run `pod spec lint XFNetwork.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "XFNetwork"
  spec.version      = "0.0.1"
  spec.summary      = "A network framework for discrete APIs based on AFNetworking3.X."
  spec.description  = <<-DESC
A network framework for discrete APIs based on AFNetworking3.X
                   DESC
  spec.homepage     = "https://github.com/Lotheve/XFNetwork"
  spec.license      = "MIT"
  spec.author             = { "Lotheve" => "lotheve1225@gmail.com" }
  spec.social_media_url   = "http://lotheve.cn"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/Lotheve/XFNetwork.git", :tag => "#{spec.version}" }

  spec.source_files  = "XFNetwork", "XFNetwork/**/*.{h,m}"
  spec.exclude_files = "XFNetwork/Exclude"

end
