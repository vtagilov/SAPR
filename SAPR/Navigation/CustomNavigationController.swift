//
//  CustomNavigationController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class CustomNavigationController: UINavigationController {

    let VCs = [ConstructionConfiguratorVC(), StickConfiguratorViewController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = VCs
    }

}
