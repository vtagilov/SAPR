//
//  CustomTabBarController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class CustomTabBarController: UITabBarController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [NodeConfiguratorViewController(), StickConfiguratorViewController()]
        
        
        tabBar.items![0].image = UIImage(systemName: "smallcircle.filled.circle")
        tabBar.items![1].image = UIImage(systemName: "plus.circle")!.withRenderingMode(.automatic)
        
    }
    

}