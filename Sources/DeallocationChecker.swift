import UIKit

@objc
public class DeallocationChecker: NSObject {

    public enum LeakState {
        case leaked
        case notLeaked
    }

    public typealias Callback = (LeakState, UIViewController.Type) -> ()

    public enum Handler {
        /// Shows alert when a leak is detected.
        case alert
        /// Calls preconditionFailure when a leak is detected.
        case precondition
        /// Customization point if you need other type of logging of leak detection, for example to the console or Fabric.
        case callback(Callback)
    }

    @objc
    public static let shared = DeallocationChecker()

    private(set) var handler: Handler?

    /// Sets up the handler then used in all `checkDeallocation*` methods.
    /// It is recommended to use DeallocationChecker only in the DEBUG configuration by wrapping this call inside
    /// ```
    /// #if DEBUG
    ///     DeallocationChecker.shared.setup(with: .alert)
    /// #endif
    /// ```
    /// call.
    ///
    /// This method isn't exposed to Obj-C because we use an enumeration that isn't compatible with Obj-C.
    public func setup(with handler: Handler) {
        self.handler = handler
    }

    /// This method asserts whether a view controller gets deallocated after it disappeared
    /// due to one of these reasons:
    /// - it was removed from its parent, or
    /// - it (or one of its parents) was dismissed.
    ///
    /// The method calls the `handler` if it's non-nil.
    ///
    /// **You should call this method only from UIViewController.viewDidDisappear(_:).**
    /// - Parameter delay: Delay after which the check if a
    ///                    view controller got deallocated is performed
    @objc(checkDeallocationOf:afterDelay:)
    public func checkDeallocation(of viewController: UIViewController, afterDelay delay: TimeInterval = 1.0) {
        guard let handler = DeallocationChecker.shared.handler else {
            return
        }

        let rootParentViewController = viewController.dch_rootParentViewController

        // `UITabBarController` keeps a strong reference to view controllers that disappeared from screen. So, we don't have to check if they've been deallocated.
        guard !rootParentViewController.isKind(of: UITabBarController.self) else {
            return
        }

        // We don't check `isBeingDismissed` simply on this view controller because it's common
        // to wrap a view controller in another view controller (e.g. a stock UINavigationController)
        // and present the wrapping view controller instead.
        if viewController.isMovingFromParent || rootParentViewController.isBeingDismissed {
            let viewControllerType = type(of: viewController)
            let disappearanceSource: String = viewController.isMovingFromParent ? "removed from its parent" : "dismissed"

            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak viewController] in
                let leakState: LeakState = viewController != nil ? .leaked : .notLeaked

                switch handler {
                case .alert:
                    if leakState == .leaked {
                        self.showAlert(for: viewControllerType)
                    }
                case .precondition:
                    if leakState == .leaked {
                        preconditionFailure("\(viewControllerType) not deallocated after being \(disappearanceSource)")
                    }
                case let .callback(callback):
                    callback(leakState, viewControllerType)
                }
            })
        }
    }

    @objc(checkDeallocationWithDefaultDelayOf:)
    public func checkDeallocationWithDefaultDelay(of viewController: UIViewController) {
        self.checkDeallocation(of: viewController)
    }

    // MARK: - Private

    private func showAlert(for viewController: UIViewController.Type) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        window.makeKeyAndVisible()

        let message = "\(viewController) is still in memory even though its view was removed from hierarchy. Please open Memory Graph Debugger to find strong references to it."
        let alertController = UIAlertController(title: "Leak Detected", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))

        window.rootViewController?.present(alertController, animated: false, completion: nil)
    }
}

extension UIViewController {

    @available(*, deprecated, message: "Please switch to using methods on DeallocationChecker. Also remember to call setup(with:) when your app starts.")
    @objc(dch_checkDeallocationAfterDelay:)
    public func dch_checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
        print("Please switch to using methods on DeallocationChecker. Also remember to call setup(with:) when your app starts.")
        DeallocationChecker.shared.checkDeallocation(of: self, afterDelay: delay)
    }

    @available(*, deprecated, message: "Please switch to using methods on DeallocationChecker. Also remember to call setup(with:) when your app starts.")
    @objc(dch_checkDeallocation)
    public func objc_dch_checkDeallocation() {
        print("Please switch to using methods on DeallocationChecker. Also remember to call setup(with:) when your app starts.")
        DeallocationChecker.shared.checkDeallocationWithDefaultDelay(of: self)
    }

    fileprivate var dch_rootParentViewController: UIViewController {
        var root = self

        while let parent = root.parent {
            root = parent
        }

        return root
    }
}
