//
//  NodeConfiguratorViewController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class ConstructionConfiguratorVC: UIViewController {
    
    var rodParametres = [RodParametres]()
    var rodMaterials = [RodMaterial]() {
        didSet { constrictionParametresView.materials = self.rodMaterials }
    }

    var supportParametres = SupportParametres(isLeftFixed: false, isRightFixed: false)
    
    var constructionView = ConstructionView()
    var constrictionParametresView = ConstructionParametersView()
    var supportParametresView = SupportParametresView()
    var materialsParametresView = MaterialsConfiguratorView()
    
    var constructionConstraints = [NSLayoutConstraint]()
    var supportConstraints = [NSLayoutConstraint]()
    var materialsConstraints = [NSLayoutConstraint]()
        
    var tapRecognizer = UITapGestureRecognizer()
    var segmentControl = UISegmentedControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction))
        view.addGestureRecognizer(tapRecognizer)
        
        materialsParametresView.delegate = self
        materialsParametresView.materials = rodMaterials
        materialsParametresView.isHidden = true
        
        constructionView.delegate = self
        
        supportParametresView.delegate = self
        supportParametresView.isHidden = true
        supportParametresView.supportParametres = self.supportParametres
        
        constrictionParametresView.delegate = self
        constrictionParametresView.rodCount = rodParametres.count
        
        configureUI()
        setConstraints()
        
        constructionView.delegate?.rodWasSelected(constructionView.stick)
    }
    
    
    func setConstruction(_ construction: Construction) {
        supportParametresView.supportParametres = construction.supportParametres
        for _ in 0 ..< construction.rodParametres.count - 1 {
            self.addStick()
        }
        materialsParametresView.materials = construction.rodMaterials
        rodParametres = construction.rodParametres
        constructionView.setParameters(constructionView.stick, CGPoint(x: 0.0, y: 0.0))
        
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

    
    private func presentNewAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    

    private func configureUI() {
        materialsParametresView.translatesAutoresizingMaskIntoConstraints = false
        constructionView.translatesAutoresizingMaskIntoConstraints = false
        constrictionParametresView.translatesAutoresizingMaskIntoConstraints = false
        supportParametresView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentControl.insertSegment(withTitle: "Стержни", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Заделки", at: 1, animated: true)
        segmentControl.insertSegment(withTitle: "Материалы", at: 2, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    @objc private func tapRecognizerAction() {
        constrictionParametresView.subviews.forEach({ $0.resignFirstResponder() })
        materialsParametresView.tableView.subviews.forEach({
            let cell = ($0 as? MaterialCell)
            cell?.elasticModulusField.resignFirstResponder()
            cell?.permissibleVoltageField.resignFirstResponder()
        })
    }
    
    @objc private func segmentControlAction(_ sender: UISegmentedControl) {
        configureConstraintsFor(sender.selectedSegmentIndex)
    }

}



extension ConstructionConfiguratorVC: ConstructionViewDelegate {
    func rodWasSelected(_ rod: UIStick) {
        if rodParametres.count > rod.number {
            constrictionParametresView.configureRod(number: rod.number, rodParameter: rodParametres[rod.number])
        } else {
            rodParametres.append(RodParametres(length: 1.0, square: 1.0, materialId: nil))
            constrictionParametresView.configureRod(number: rod.number, rodParameter: rodParametres[rod.number])
        }
        constrictionParametresView.rodCount = rodParametres.count
    }
}



extension ConstructionConfiguratorVC: ConstructionParametersDelegate {
    
    func deleteLastStick() {
        if rodParametres.count == 1 {
            rodParametres = [RodParametres(length: 1.0, square: 1.0)]
            constrictionParametresView.configureRod(number: 0, rodParameter: rodParametres.first!)
        } else {
            rodParametres.removeLast()
            constructionView.deleteLastStick()
        }
    }
    
    func addStick() {
        rodParametres.append(RodParametres(length: 1.0, square: 1.0))
        constructionView.addStickTo(.right)
    }
    
    func getParametres(_ rodNumber: Int) -> RodParametres {
        return rodParametres[rodNumber]
    }
    
    func setParametrs(_ number: Int, _ rodParameter: RodParametres) {
        self.rodParametres[number] = rodParameter
    }
    
}



extension ConstructionConfiguratorVC: SupportParametresViewDelegate {
    func setParametrs(_ parametres: SupportParametres) {
        self.supportParametres = parametres
        constructionView.configureSupports(self.supportParametres)
    }
}



extension ConstructionConfiguratorVC: MaterialConfiguratorDelegate {
    func setMaterials(materials: [RodMaterial]) {
        self.rodMaterials = materials
    }
    
}



// MARK: - Constraints
extension ConstructionConfiguratorVC {
    private func setConstraints() {
        
        for subView in [constructionView, constrictionParametresView, segmentControl, supportParametresView ,materialsParametresView] {
            view.addSubview(subView)
        }
        
        constructionConstraints = [
            constrictionParametresView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            constrictionParametresView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            constrictionParametresView.leftAnchor.constraint(equalTo: view.leftAnchor),
            constrictionParametresView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        supportConstraints = [
            supportParametresView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            supportParametresView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            supportParametresView.leftAnchor.constraint(equalTo: view.leftAnchor),
            supportParametresView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        materialsConstraints = [
            materialsParametresView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            materialsParametresView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            materialsParametresView.leftAnchor.constraint(equalTo: view.leftAnchor),
            materialsParametresView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        NSLayoutConstraint.activate(constructionConstraints)
        NSLayoutConstraint.activate([
            
            constructionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constructionView.heightAnchor.constraint(equalToConstant: 200),
            constructionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: constructionView.bottomAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 40),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor)
            
        ])
        
    }
    
    
    // 0 - constrictionParametresView, 1 - supports, 2 - materials
    private func configureConstraintsFor(_ num: Int) {
        NSLayoutConstraint.deactivate(supportConstraints)
        NSLayoutConstraint.deactivate(constructionConstraints)
        NSLayoutConstraint.deactivate(materialsConstraints)
        if num == 0 {
            NSLayoutConstraint.activate(constructionConstraints)
            supportParametresView.isHidden = true
            materialsParametresView.isHidden = true
            constrictionParametresView.isHidden = false
            
        } else if num == 1 {
            NSLayoutConstraint.activate(supportConstraints)
            constrictionParametresView.isHidden = true
            materialsParametresView.isHidden = true
            supportParametresView.isHidden = false
        } else if num == 2 {
            NSLayoutConstraint.activate(materialsConstraints)
            constrictionParametresView.isHidden = true
            supportParametresView.isHidden = true
            materialsParametresView.isHidden = false
        }
    }
}
