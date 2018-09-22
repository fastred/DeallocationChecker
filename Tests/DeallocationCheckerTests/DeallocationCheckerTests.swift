//
//  DeallocationCheckerTests.swift
//  DeallocationChecker
//
//  Created by Arkadiusz Holko on {TODAY}.
//  Copyright © 2017 DeallocationChecker. All rights reserved.
//

import UIKit
import XCTest
import DeallocationChecker

class UIStack<T: UIViewController> {

    var rootWindow: UIWindow!

    func setupTopLevelUI(withViewController viewController: T) {
        rootWindow = UIWindow(frame: UIScreen.main.bounds)
        rootWindow.isHidden = false
        rootWindow.rootViewController = viewController
        _ = viewController.view
        viewController.viewWillAppear(false)
        viewController.viewDidAppear(false)
    }

    func tearDownTopLevelUI() {
        guard let rootWindow = rootWindow,
            let rootViewController = rootWindow.rootViewController as? T else {
                XCTFail("tearDownTopLevelUI() was called without setupTopLevelUI() being called first")
                return
        }
        rootViewController.viewWillDisappear(false)
        rootViewController.viewDidDisappear(false)
        rootWindow.rootViewController = nil
        rootWindow.isHidden = true
        self.rootWindow = nil
    }
}


private class LeakingViewController: UIViewController {

    static var retained: LeakingViewController?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        type(of: self).retained = self

        DeallocationCheckerManager.shared.checkDeallocation(of: self)
    }
}

private class NotLeakingViewController: UIViewController {

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        DeallocationCheckerManager.shared.checkDeallocation(of: self)
    }
}

class DeallocationCheckerInNavigationControllerTests: XCTestCase {

    var uiStack: UIStack<UINavigationController>!
    private var navigationController: UINavigationController!

    override func setUp() {
        super.setUp()

        uiStack = UIStack()
        navigationController = UINavigationController(rootViewController: UIViewController())
        uiStack.setupTopLevelUI(withViewController: navigationController)
    }

    func testLeaked() {
        let expectation = self.expectation(description: "retained")

        var leakedState: DeallocationCheckerManager.LeakedState?
        autoreleasepool { () -> Void in
            let callback: DeallocationCheckerManager.Callback = { receivedLeakedState, _ in
                leakedState = receivedLeakedState
                expectation.fulfill()
            }

            DeallocationCheckerManager.shared.setup(with: .callback(callback))

            navigationController.pushViewController(LeakingViewController(), animated: false)
            navigationController.popViewController(animated: false)
        }
        waitForExpectations(timeout: 3.0, handler: nil)

        XCTAssertEqual(leakedState, .leaked)
    }

    func testNotLeaked() {
        let expectation = self.expectation(description: "retained")

        var leakedState: DeallocationCheckerManager.LeakedState?
        autoreleasepool { () -> Void in
            let callback: DeallocationCheckerManager.Callback = { receivedLeakedState, _ in
                leakedState = receivedLeakedState
                expectation.fulfill()
            }

            DeallocationCheckerManager.shared.setup(with: .callback(callback))

            navigationController.pushViewController(NotLeakingViewController(), animated: false)
            navigationController.popViewController(animated: false)
            navigationController.pushViewController(UIViewController(), animated: false)
        }
        waitForExpectations(timeout: 3.0, handler: nil)

        XCTAssertEqual(leakedState, .notLeaked)
    }
}
