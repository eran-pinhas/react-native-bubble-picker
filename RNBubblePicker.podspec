require 'json'
package = JSON.parse(File.read(File.join(__dir__, './', 'package.json')))

Pod::Spec.new do |s|
  s.name          = "RNBubblePicker"
  s.version       = package['version']
  s.summary       = package['description']
  s.homepage     = "https://github.com/eran-pinhas/react-native-Bubble-Picker"
  s.license      = package['license']
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Eran Pinhas" => "eran.pinhas@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/eran-pinhas/react-native-Bubble-Picker.git", :tag => "master" }
  s.source_files  = "ios/**/*.{h,m,swift}"
  s.requires_arc = true


  s.dependency "React"
  s.dependency "SIFloatingCollection"
  
  s.swift_version = "4.2"
end

  