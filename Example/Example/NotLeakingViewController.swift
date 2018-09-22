//
//  NotLeakingViewController.swift
//  Example
//
//  Created by Arkadiusz Holko on 22/09/2018.
//  Copyright © 2018 Arkadiusz Holko. All rights reserved.
//

import UIKit
import DeallocationChecker

class NotLeakingViewController: UIViewController {

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        DeallocationCheckerManager.shared.checkDeallocation(of: self)
    }
}
