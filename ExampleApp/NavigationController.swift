//
//  NavigationController.swift
//  ExampleApp
//
//  Created by Arkadiusz Holko on 22/09/2018.
//  Copyright © 2018 DeallocationChecker. All rights reserved.
//

import UIKit
import DeallocationChecker

class NavigationController: UINavigationController {

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        DeallocationCheckerManager.shared.checkDeallocation(of: self)
    }
}
