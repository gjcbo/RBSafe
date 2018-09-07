

Pod::Spec.new do |s|

  s.name         = "RBSafe"
  s.version      = "0.0.3"
  s.summary      = "Avaid normal crash."
  s.homepage     = "https://github.com/gjcbo/RBSafe"
  s.platform     = :ios, '9.0'
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "RaoBo" => "421624358@qq.com" }
  s.source       = { :git => 'https://github.com/gjcbo/RBSafe.git', :tag => s.version }
  s.source_files  =  'RBSafe/*.{h,m}'
  s.requires_arc = true
end
