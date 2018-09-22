# DeallocationChecker

Learn about leaking view controllers without opening Instruments.

## Usage

First, enable the library by calling (for example from your application delegate):

```swift
#if DEBUG
    DeallocationChecker.shared.setup(with: .alert) // There are other options than .alert too!
#endif
```

Then, in your view controllers **from within `viewDidDisappear(_:) override`**, call:

```swift
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    DeallocationChecker.shared.checkDeallocation(of: self)
}
```

If a view controller isn’t deallocated after disappearing for good, you'll see a helpful alert:

<img src="Resources/demo.gif" width="370" height="662" alt="Leaked view controller demo">

At this point we can simply open the [Memory Graph Debugger](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/debugging_with_xcode/chapters/special_debugging_workflows.html#//apple_ref/doc/uid/TP40015022-CH9-DontLinkElementID_1) to investigate the reason of a cycle.

## Installation

### CocoaPods

Add the line `pod "DeallocationChecker"` to your `Podfile`

### Carthage
Add the line `github "fastred/DeallocationChecker"` to your `Cartfile`

## Author

Project created by [Arek Holko](http://holko.pl) ([@arekholko](https://twitter.com/arekholko) on Twitter).
