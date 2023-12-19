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
    
    var construction: Construction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [ConstructionConfiguratorVC(), LoadsConfiguratorVC(), CalculationViewController()]
        viewControllers?[0].title = "Конструкция"
        viewControllers?[1].title = "Нагрузки"
        viewControllers?[2].title = "Расчет"
        
        tabBar.items![0].image = UIImage(systemName: "smallcircle.filled.circle")
        tabBar.items![1].image = UIImage(systemName: "plus.circle")!.withRenderingMode(.automatic)
        tabBar.items![2].image = UIImage(systemName: "arrow.right")!.withRenderingMode(.automatic)
        self.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = .black
        let item = UIBarButtonItem(title: "Cохранить", style: .plain, target: self, action: #selector(saveButtonAction))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(item, animated: true)
    }
    
    
    func setConstruction(_ construction: Construction) {
//        self.delegate = nil
        self.title = construction.name
        self.construction = construction
        let constructionVC = viewControllers![0] as! ConstructionConfiguratorVC
        constructionVC.setConstruction(construction)
        let loadsVC = viewControllers![1] as! LoadsConfiguratorVC
        loadsVC.setConstruction(construction)
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
        let alertController = UIAlertController(title: "Введите название", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название"
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
        let vc = viewControllers![0] as! ConstructionConfiguratorVC
        let vc2 = viewControllers![1] as! LoadsConfiguratorVC
        let vc3 = viewControllers![2] as! CalculationViewController
        let loads = vc2.getLoads()
        construction = Construction(supportParametres: vc.supportParametres, rodParametres: vc.rodParametres, rodMaterials: vc.rodMaterials, focusedLoads: loads.focused, distributedLoads: loads.distributed)
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
            switch index {
            case 0:
                break
            case 1:
                vc2.constructionLoadsView.setPowerType(isFocused: true)
                vc2.loadsConfiguratorView.loadsTypeSegmentControl.selectedSegmentIndex = 0
                vc2.setConstruction(construction!)
            case 2:
                vc3.calculate(construction!)
            default:
                break
            }
        }
    }
}


