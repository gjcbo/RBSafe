#
#  Be sure to run `pod spec lint RBSafe.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "RBSafe"
  s.version      = "0.0.1"
  s.summary      = "Avoid crash"
  s.description  = <<-DESC
			 Avoid Crash 
                   DESC

  s.homepage     = "https://github.com/gjcbo/RBSafe"
  s.license      = { :type => "MIT", :file => "LICENSE"}
  s.author             = { "RaoBo" => "421624358@qq.com" }
  s.platform	 = :ios, "9.0"
  s.source       = { :git => "https://github.com/gjcbo/RBSafe.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "RBSafe/RBSafe/RBSafe/*.{h,m}"
  s.requires_arc = true

#  s.source_files  = "Classes", "Classes/**/*.{h,m}"
#  s.exclude_files = "Classes/Exclude"

end
