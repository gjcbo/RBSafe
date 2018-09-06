
Pod::Spec.new do |s|

  s.name         = "RBSafe"
  s.version      = "0.0.2"
  s.summary      = "Avoid crash"

  s.homepage     = "https://github.com/gjcbo/RBSafe"
 
  s.license      = "MIT"

  s.author	 = { "RaoBo" => "421624358@qq.com" }
  s.platform	 = :ios, "9.0"

  s.source       = { :git => "https://github.com/gjcbo/RBSafe.git", :tag => "s.version }

  s.source_files  = "RBSafe"
  s.requires_arc = true

end
