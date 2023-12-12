//
//  CustomTabBarController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit
import CoreData

class CustomTabBarController: UITabBarController {
    
    let constructionSaver = ConstructionSaver()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ConstructionConfiguratorVC(), LoadsConfiguratorVC()]
        viewControllers?[0].title = "Конструкция"
        viewControllers?[1].title = "Нагрузки"
        
        tabBar.items![0].image = UIImage(systemName: "smallcircle.filled.circle")
        tabBar.items![1].image = UIImage(systemName: "plus.circle")!.withRenderingMode(.automatic)
        self.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let item = UIBarButtonItem(title: "Cохранить", style: .plain, target: self, action: #selector(saveButtonAction))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(item, animated: true)
    }
    
    
    @objc func saveButtonAction() {
        var constructionName = ""
        showAlertWithInput { name in
            if name == nil || name == "" {
                self.showAlert(message: "Название пустое")
                return
            }
            var names = [String]()
            self.constructionSaver.constructions.forEach({ construction in
                if construction.name != nil {
                    names.append(construction.name!)
                }
            })
            if names.contains(name!) {
                self.showAlert(message: "Название уже занято")
                return
            }
            constructionName = name!
            
            let constructionConfiguratorVC = self.viewControllers![0] as! ConstructionConfiguratorVC
            let loadsConfiguratorVC = self.viewControllers![1] as! LoadsConfiguratorVC
            
            let stickCount = constructionConfiguratorVC.rodParametres.count
            var focusedLoads = loadsConfiguratorVC.focusedLoads
            var distributedLoads = loadsConfiguratorVC.distributedLoads
            var rodParametres = constructionConfiguratorVC.rodParametres
            
            while focusedLoads.count <= stickCount {
                focusedLoads.append(0.0)
            }
            
            while distributedLoads.count < stickCount {
                distributedLoads.append(0.0)
            }
            
            for i in 0 ..< rodParametres.count {
                if rodParametres[i].materialId == nil {
                    rodParametres[i].materialId = -1
                }
            }
            
            let construction = Construction(name: constructionName, supportParametres: constructionConfiguratorVC.supportParametres, rodParametres: rodParametres, rodMaterials: constructionConfiguratorVC.rodMaterials, focusedLoads: focusedLoads, distributedLoads: distributedLoads)
            
            self.constructionSaver.saveConstruction(construction: construction)
            self.constructionSaver.loadConstructions()
        }
    }
    

    private func showAlertWithInput(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "Введите значение", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Значение"
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(nil)
        }
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                completion(nil)
                return
            }
            completion(textField.text)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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


