Pod::Spec.new do |spec|
  spec.name         = "IRRadioButton-iOS-swift"
  spec.version      = "0.1.0"
  spec.summary      = "A powerful radio button of iOS."
  spec.description  = "A powerful radio button of iOS."
  spec.homepage     = "https://github.com/irons163/IRRadioButton-iOS-swift.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/irons163/IRRadioButton-iOS-swift.git", :tag => spec.version.to_s }
  spec.source_files  = "IRRadioButton-iOS-swift/**/*.{h,m,swift}"
#  spec.resources = ["IRRadioButton-iOS-swift/**/*.png"]
end