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
        self.view.backgroundColor = .black
        let item = UIBarButtonItem(title: "Cохранить", style: .plain, target: self, action: #selector(saveButtonAction))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(item, animated: true)
    }
    
    
    func setConstruction(_ construction: Construction) {
        self.title = construction.name
        let constructionVC = viewControllers![0] as! ConstructionConfiguratorVC
        let loadsVC = viewControllers![1] as! LoadsConfiguratorVC
        
        for _ in 1 ..< construction.rodParametres.count {
            constructionVC.constructionView.addStickTo(.right)
        }
        constructionVC.setParametrs(construction.supportParametres)
        constructionVC.supportParametresView.supportParametres = construction.supportParametres
        constructionVC.rodParametres = construction.rodParametres
        constructionVC.rodMaterials = construction.rodMaterials
        constructionVC.materialsParametresView.materials = construction.rodMaterials
        loadsVC.focusedLoads = construction.focusedLoads
        loadsVC.distributedLoads = construction.distributedLoads
        for i in 0 ..< construction.focusedLoads.count {
            loadsVC.constructionLoadsView.setFocusedLoad(numOfNode: i, power: construction.focusedLoads[i])
            loadsVC.setParametres(focusedPower: construction.focusedLoads[i])
        }
        for i in 0 ..< construction.distributedLoads.count {
            loadsVC.constructionLoadsView.setDistributedLoad(numOfRod: i, power: construction.distributedLoads[i])
            loadsVC.setParametres(distributedPower: construction.distributedLoads[i])
        }
    }
    
    @objc func saveButtonAction() {
        if self.title != nil {
             let constructionName = self.title!
            constructionSaver.deleteConstruction(name: constructionName)
            var construction = self.getCurrentConstruction()
            construction.name = constructionName
            self.constructionSaver.saveConstruction(construction: construction)
            self.constructionSaver.loadConstructions()
            return
        }

        showAlertWithInput { name, isCanceled  in
            if isCanceled {
                return
            }
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
            var construction = self.getCurrentConstruction()
            construction.name = name!
            self.constructionSaver.saveConstruction(construction: construction)
            self.constructionSaver.loadConstructions()
        }
    }
    
    
    private func getCurrentConstruction() -> Construction {
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
        let construction = Construction(supportParametres: constructionConfiguratorVC.supportParametres, rodParametres: rodParametres, rodMaterials: constructionConfiguratorVC.rodMaterials, focusedLoads: focusedLoads, distributedLoads: distributedLoads)
        return construction
    }

    
    private func showAlertWithInput(completion: @escaping (String?, Bool) -> Void) {
        let alertController = UIAlertController(title: "Введите значение", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Значение"
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            completion(nil, true)
        }
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                completion(nil, false)
                return
            }
            completion(textField.text, false)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: false)
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


