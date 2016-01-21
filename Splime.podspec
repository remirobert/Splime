Pod::Spec.new do |s|
  s.name                  = "Splime"
  s.version               = "1.0.1"
  s.summary               = "Splime, is a tool, lets you to split a video into frames."
  s.homepage              = "https://github.com/remirobert/Splime"
  s.ios.deployment_target = '8.0'
  s.license               = "MIT"

  s.social_media_url      = 'https://twitter.com/remi936'
  s.author                = { "rémi " => "remirobert33530@gmail.com" }

  s.source                = { :git => "https://github.com/remirobert/Splime.git", :tag => "1.0.1" }
  s.source_files          = 'Splime/*.swift'
end
