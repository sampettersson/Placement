<img src="https://user-images.githubusercontent.com/5459507/190897413-f4b6dad2-88ec-4453-850b-a9e4ff801bd5.png" />

A polyfill for the new Layout protocol from iOS 16. Supports iOS 14 and above, on iOS 16 Placement favors the built in Layout protocol and uses that instead of Placements own layouter.

## Documentation

You can find the documentation at [placement.sampettersson.com](https://placement.sampettersson.com/)

## Installation

#### [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

```shell
https://github.com/sampettersson/Placement.git
```

#### [Carthage](https://github.com/Carthage/Carthage)

```shell
github "sampettersson/Placement" >= VERSION
```

#### [Cocoa Pods](https://github.com/CocoaPods/CocoaPods)

```ruby
platform :ios, '9.0'
use_frameworks!

target 'Your App Target' do
  pod 'Placement', '~> VERSION'
end
```
