
Pod::Spec.new do |s|

  s.name         = "RBSafe"
  s.version      = "0.0.2"
  s.summary      = "Avoid crash"

  s.homepage     = "https://github.com/gjcbo/RBSafe"
 
  s.license      = "MIT"

  s.author	 = { "RaoBo" => "421624358@qq.com" }
  s.platform	 = :ios, "9.0"

  s.source       = { :git => "https://github.com/gjcbo/RBSafe.git", :tag => "#{s.version}" }

  s.source_files  = "Sources", "Sources/*.{h,m}"
  s.requires_arc = true

#  s.source_files  = "Classes", "Classes/**/*.{h,m}"
#  s.exclude_files = "Classes/Exclude"

end
