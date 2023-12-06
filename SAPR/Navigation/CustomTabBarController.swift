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
        self.viewControllers = [ConstructionConfiguratorVC(), LoadsConfiguratorVC()]
        viewControllers?[0].title = "Конструкция"
        viewControllers?[1].title = "Нагрузки"
        
        tabBar.items![0].image = UIImage(systemName: "smallcircle.filled.circle")
        tabBar.items![1].image = UIImage(systemName: "plus.circle")!.withRenderingMode(.automatic)
//        tabBar.items![2].image = UIImage(systemName: "location")!.withRenderingMode(.automatic)
        self.delegate = self
    }
    

}

extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            switch index {
            case 0:
                print()
            case 1:
                let vc = viewControllers![0] as! ConstructionConfiguratorVC
                let vc2 = viewControllers![1] as! LoadsConfiguratorVC
                
                vc2.constructionLoadsView.removeAllRods()
                vc2.constructionLoadsView.setPowerType(isFocused: true)
                vc2.loadsConfiguratorView.loadsTypeSegmentControl.selectedSegmentIndex = 0
                
                var stick = vc.constructionView.stick
                while stick.rightStick != nil {
                    vc2.constructionLoadsView.addStickTo(.right)
                    stick = stick.rightStick!
                }
                
                vc2.constructionLoadsView.setNodePoints()
                
                
            default:
                break
            }
        }
    }
}
