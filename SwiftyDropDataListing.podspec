
Pod::Spec.new do |s|

  s.name         = "SwiftyDropDataListing"
  s.version      = "0.0.1"
  s.summary      = "SwiftyDropDataListing provides a simple and effective way to browse, view, and get files(download) from Dropbox."

  s.homepage     = "https://github.com/Sahilberi/SwiftyDropDataListing"
  # s.screenshots  = "https://cloud.githubusercontent.com/assets/7422405/21468458/20db5754-ca37-11e6-8a2b-7200affdffa0.jpg"

  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author = { "Sahil" => "Sahilberi97@gmail.com" }
  s.source = { :git => 'https://github.com/Sahilberi/SwiftyDropDataListing.git', :tag => s.version }
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.source_files = "Source/**/*.{swift,bundle}"
  s.requires_arc = true
  s.dependency "SwiftyDropbox", "~> 4.1.1"

end
