//
//  LeakingViewController.swift
//  Example
//
//  Created by Arkadiusz Holko on 14/09/2018.
//  Copyright © 2018 Arkadiusz Holko. All rights reserved.
//

import UIKit
import DeallocationChecker

private var retained: LeakingViewController?

class LeakingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        retained = self

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        dch_checkDeallocation()
    }
}
