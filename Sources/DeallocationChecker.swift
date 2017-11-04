import UIKit

extension UIViewController {

    /// This method asserts whether a view controller gets deallocated after it disappeared
    /// due to one of these reasons:
    /// - it was removed from its parent, or
    /// - it (or one of its parents) was dismissed.
    ///
    /// **You should call this method only from UIViewController.viewDidDisappear(_:).**
    /// - Parameter delay: Delay after which the check if a
    ///                    view controller got deallocated is performed
    @objc(dch_checkDeallocationAfterDelay:)
    public func dch_checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
        #if DEBUG
            let rootParentViewController = dch_rootParentViewController

            // We don't check `isBeingDismissed` simply on this view controller because it's common
            // to wrap a view controller in another view controller (e.g. a stock UINavigationController)
            // and present the wrapping view controller instead.
            if isMovingFromParentViewController || rootParentViewController.isBeingDismissed {
                let viewControllerType = type(of: self)
                let disappearanceSource: String = isMovingFromParentViewController ? "removed from its parent" : "dismissed"

                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
                    assert(self == nil, "\(viewControllerType) not deallocated after being \(disappearanceSource)")
                })
            }
        #endif
    }

    @objc(dch_checkDeallocation)
    public func objc_dch_checkDeallocation() {
        self.dch_checkDeallocation()
    }

    private var dch_rootParentViewController: UIViewController {
        var root = self

        while let parent = root.parent {
            root = parent
        }

        return root
    }
}
