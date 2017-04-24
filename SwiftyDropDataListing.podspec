
Pod::Spec.new do |s|

  s.name         = "SwiftyDropDataListing"
  s.version      = "0.0.1"
  s.summary      = "SwiftyDropDataListing provides a simple and effective way to browse, view, and get files(download) From Dropbox."

  s.description  = <<- In SwiftyDropDataListing users will getting all files. When a user tap on file it get downloaded and it calls a Delegate method getDropboxSelectedData.

  s.homepage     = "https://github.com/Sahilberi/SwiftyDropDataListing"
  # s.screenshots  = "https://cloud.githubusercontent.com/assets/7422405/21468458/20db5754-ca37-11e6-8a2b-7200affdffa0.jpg"



  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

    s.author             = { "Sahil" => "Sahilberi97@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "9.0"


s.source_files  = "DBListingViewController.{h,m}"
#  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  s.resource  = "icon.png"
  # s.resources = "DroplightIcons.bundle"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

   s.dependency "SwiftyDropbox', '~> 4.1.1"

end
