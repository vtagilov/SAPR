//
//  LoadsConfiguratorVC.swift
//  SAPR
//
//  Created by Владимир on 24.11.2023.
//

import UIKit

class LoadsConfiguratorVC: UIViewController {

    var constructionLoadsView = ConstructionLoadsView()
    let loadsConfiguratorView = LoadsConfiguratorView()
    
    var tapRecognizer = UITapGestureRecognizer()
    
    var focusedLoads = [Double]()
    var distributedLoads = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    
    func configureUI() {
        loadsConfiguratorView.delegate = self
        constructionLoadsView.constructionLoadsViewDelegate = self
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func setConstruction(_ construction: Construction) {
        constructionLoadsView.removeAllRods()
        for _ in 1 ..< construction.rodParametres.count {
            constructionLoadsView.addStickTo(.right)
        }
        constructionLoadsView.configureSupports(construction.supportParametres)
        constructionLoadsView.setNodePoints()
        self.focusedLoads = construction.focusedLoads
        for i in 0 ..< construction.focusedLoads.count {
            constructionLoadsView.setFocusedLoad(numOfNode: i, power: construction.focusedLoads[i])
        }
        self.distributedLoads = construction.distributedLoads
        for i in 0 ..< construction.distributedLoads.count {
            constructionLoadsView.setDistributedLoad(numOfRod: i, power: construction.distributedLoads[i])
        }
    }
    
    func getLoads() -> (focused: [Double], distributed: [Double]) {
        while constructionLoadsView.selectedNode >= focusedLoads.count {
            focusedLoads.append(0.0)
        }
        while constructionLoadsView.selectedRod >= distributedLoads.count {
            distributedLoads.append(0.0)
        }
        return (focusedLoads, distributedLoads)
    }
    
    
    @objc private func tapRecognizerAction() {
        loadsConfiguratorView.subviews.forEach({ $0.resignFirstResponder() })
    }
    
    
    func presentNewAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}



extension LoadsConfiguratorVC: LoadsConfiguratorViewDelegate {
    
    func setPowerType(isFocused: Bool) {
        constructionLoadsView.setPowerType(isFocused: isFocused)
        if isFocused {
            nodeWasSelected(numOfNode: 0, direction: .right)
        } else {
            rodWasSelected(numOfRod: 0)
        }
    }
    
    
    func setParametres(focusedPower: Double) {
        while constructionLoadsView.selectedNode >= focusedLoads.count {
            focusedLoads.append(0.0)
        }
        focusedLoads[constructionLoadsView.selectedNode] = focusedPower
        constructionLoadsView.setFocusedLoad(numOfNode: constructionLoadsView.selectedNode, power: focusedPower)
        print("loadsVC focused - ", focusedLoads)
    }
    
    
    func setParametres(distributedPower: Double) {
        while constructionLoadsView.selectedRod >= distributedLoads.count {
            distributedLoads.append(0.0)
        }
        distributedLoads[constructionLoadsView.selectedRod] = distributedPower
        constructionLoadsView.setDistributedLoad(numOfRod: constructionLoadsView.selectedRod, power: distributedPower)
    }
    
    
    func showErrorAlert(message: String) {
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.presentNewAlert(message: message)
            }
        } else {
            presentNewAlert(message: message)
        }
    }
    
}


extension LoadsConfiguratorVC: ConstructionLoadsViewDelegate {
    
    func rodWasSelected(numOfRod: Int) {
        while numOfRod >= distributedLoads.count {
            distributedLoads.append(0.0)
        }
        loadsConfiguratorView.distributedPowerField.text = "\(distributedLoads[numOfRod])"
        loadsConfiguratorView.powerLabel.text = "Распределенная сила на стержне №\(numOfRod + 1)"
    }
    
    
    func nodeWasSelected(numOfNode: Int, direction: Direction) {
        while numOfNode >= focusedLoads.count {
            focusedLoads.append(0.0)
        }
        loadsConfiguratorView.focusedPowerField.text = "\(focusedLoads[numOfNode])"
        loadsConfiguratorView.powerLabel.text = "Сосредоточенная сила на узле №\(numOfNode + 1)"
    }
    
    
}




// MARK: - Constraints
extension LoadsConfiguratorVC {
    private func setConstraints() {
        
        for subview in [constructionLoadsView, loadsConfiguratorView] {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            constructionLoadsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constructionLoadsView.heightAnchor.constraint(equalToConstant: 200),
            constructionLoadsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionLoadsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            loadsConfiguratorView.topAnchor.constraint(equalTo: constructionLoadsView.bottomAnchor),
            loadsConfiguratorView.leftAnchor.constraint(equalTo: view.leftAnchor),
            loadsConfiguratorView.rightAnchor.constraint(equalTo: view.rightAnchor),
            loadsConfiguratorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

