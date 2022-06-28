Pod::Spec.new do |s|
  s.name         = "DeallocationChecker"
  s.version      = "3.0.2"
  s.summary      = "Learn about leaking view controllers without opening Instruments."
  s.description  = <<-DESC
    DeallocationChecker asserts that a view controller gets deallocated after
    its view is removed from the view hierarchy.
  DESC
  s.homepage     = "https://github.com/fastred/DeallocationChecker"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Arkadiusz Holko" => "fastred@fastred.org" }
  s.social_media_url   = "https://twitter.com/arekholko"
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/fastred/DeallocationChecker.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation", "UIKit"
end
