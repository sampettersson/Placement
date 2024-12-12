Pod::Spec.new do |spec|
  spec.name         = "Placement"
  spec.version      = "1.1.1"
  spec.summary      = "Polyfill for iOS 16 Layout protocol supporting iOS 14 and above"

  spec.description  = <<-DESC
                   A polyfill for the new Layout protocol from iOS 16. Supports iOS 14 and above, on iOS 16 Placement favors the built in Layout protocol and uses that instead of Placements own layouter.
		   DESC

  spec.homepage     = "https://github.com/sampettersson/Placement"
  spec.license      = "MIT"
  spec.author             = { "Sam Pettersson" => "sam@sampettersson.com" }
  spec.ios.deployment_target = "14.0"
  spec.tvos.deployment_target = "14.0"
  spec.visionos.deployment_target = "1.0"

  spec.source       = { :git => "https://github.com/sampettersson/Placement.git", :tag => "#{spec.version}" }

  spec.source_files  = "Sources/Placement/**/*.{swift}"
  spec.swift_version = '5.7'

end
