//
//  CustomNavigationController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let VCs = [NodeConfiguratorViewController(), StickConfiguratorViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = VCs
    }

}
