# Pippin

![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)

`Pippin` is a collection of tools to scaffold iOS app infrastructure and assist in development tasks like writing code, testing and debugging.

Getting started with a default setup is as easy as declaring a Podfile dependency:

```ruby
pod 'PippinAdapters'
```

and, at some point during your app launch sequence:

```swift
let environment = Environment.default(
    bugReportRecipients: ["andrew@tworingsoft.com"],
    touchVizRootVC: UIViewController(nibName: nil, bundle: nil) // optional
)

// Crashlytics is a special situation
environment.crashReporter = CrashlyticsAdapter(debug: true)

// other optional peripherals
environment.locator = CoreLocationAdapter(locatorDelegate: self)

environment.connectEnvironment()
```

You've just gotten the following, with minimal boilerplate: 

- logging
- crash reporting
- bug reporting
- progress indicators
- alert dialogs
- fonts
- app and launch information
- data model
- touch visualization
- launch arguments and environment variables
- an authorized `CLLocationManager` (an authorized `AVCaptureDevice` may be obtained similarly)

## Podspecs

There are four podspecs to deliver these tools, see each's README for more information:

- [Pippin](Sources/Pippin)
- [PippinAdapters](Sources/PippinAdapters)
- [PippinDebugging](Sources/PippinDebugging)
- [PippinTesting](Sources/PippinTesting)

# Contribute

Issues and pull requests are welcome! 

## Testing

`rake test`

Files under Tests/ are declared in `Pippin`'s `test_spec`, and likewise for `PippinTesting`. These are brought into the root xcworkspace to run as unit tests using the Podfile's `testspecs` declaration.

Also runs an integration smoke test, which generates an Xcode project for each spec and subspec, in each of Swift and Objective-C, to try building after `pod install`. Each project is deposited under `PippinTests/SmokeTests`. `PippinTests/` also contains the template project source code in `ObjcApp/` and `SwiftApp/`, plus the template Podfile.

# Thanks!

If this project helped you, please consider <a href="https://www.paypal.me/armcknight">leaving a tip</a> 🤗
