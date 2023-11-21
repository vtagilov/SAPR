//
//  NodeConfiguratorViewController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class ConstructionConfiguratorVC: UIViewController {
    
    var rodParametres = [RodParametres]()
    
    var supportParametres = SupportParametres(isLeftFixed: false, isRightFixed: false)
    
    var constructionView: ConstructionView?
    
    var constrictionParametresView: ConstructionParametersView?
    
    var supportParametresView: SupportParametresView?
    
    var constructionConstraints = [NSLayoutConstraint]()
    var supportConstraints = [NSLayoutConstraint]()
    
    var tapRecognizer: UITapGestureRecognizer?
    
    var segmentControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Конструкция"
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognizerAction))
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        constructionView = ConstructionView(CGSize(width: view.frame.width, height: 200))
        constructionView?.delegate = self
        
        supportParametresView = SupportParametresView(delegate: self, supportParametres: supportParametres, size: CGSize(width: view.frame.width, height: 200))
        supportParametresView?.isHidden = true
        
        constrictionParametresView = ConstructionParametersView(CGSize(width: view.frame.width, height: 200))
        constrictionParametresView?.delegate = self
        constrictionParametresView?.rodCount = rodParametres.count
        
        configureUI()
        setConstraints()
        
        constructionView?.delegate?.setParametrs(constructionView!.stick)
        
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

    func presentNewAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    

    private func configureUI() {
        constructionView?.translatesAutoresizingMaskIntoConstraints = false
        constrictionParametresView?.translatesAutoresizingMaskIntoConstraints = false
        supportParametresView?.translatesAutoresizingMaskIntoConstraints = false
        segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Стержни", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Узлы", at: 1, animated: true)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(segmentControlAction), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    @objc private func tapRecognizerAction() {
        constrictionParametresView?.contentView.subviews.forEach({ $0.resignFirstResponder() })
    }
    
    @objc private func segmentControlAction(_ sender: UISegmentedControl) {
        configureConstraintsFor(sender.selectedSegmentIndex)
    }

}



extension ConstructionConfiguratorVC: ConstructionViewDelegate {
    func setParametrs(_ rod: UIStick) {
        
        if rodParametres.count > rod.number {
            constrictionParametresView?.configureRod(number: rod.number, rodParameter: rodParametres[rod.number])
        } else {
            rodParametres.append(RodParametres(length: 1.0, square: 1.0, material: RodMaterial(elasticModulus: 1.0, permissibleVoltage: 1.0)))
            constrictionParametresView?.configureRod(number: rod.number, rodParameter: rodParametres[rod.number])
        }
        constrictionParametresView?.rodCount = rodParametres.count
    }
}



extension ConstructionConfiguratorVC: ConstructionParametersDelegate {
    func getParametres(_ rodNumber: Int) -> RodParametres {
        if rodParametres[rodNumber].copiedFrom != nil {
            return rodParametres[rodParametres[rodNumber].copiedFrom!]
        }
        return rodParametres[rodNumber]
    }
    
    func setParametrs(_ number: Int, _ rodParameter: RodParametres) {
        self.rodParametres[number] = rodParameter
    }
    
    func deleteRod(_ numer: Int) {
        print("delete rod... in progress..")
    }
    
}




// MARK: - Constraints
extension ConstructionConfiguratorVC {
    private func setConstraints() {
        
        for subView in [constructionView!, constrictionParametresView!, segmentControl, supportParametresView!] {
            view.addSubview(subView)
        }
        
        constructionConstraints = [
            constrictionParametresView!.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            constrictionParametresView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            constrictionParametresView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            constrictionParametresView!.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        supportConstraints = [
            supportParametresView!.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
            supportParametresView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            supportParametresView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            supportParametresView!.rightAnchor.constraint(equalTo: view.rightAnchor),
        ]
        
        NSLayoutConstraint.activate(constructionConstraints)
        NSLayoutConstraint.activate([
            
            constructionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constructionView!.heightAnchor.constraint(equalToConstant: 200),
            constructionView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            segmentControl.topAnchor.constraint(equalTo: constructionView!.bottomAnchor),
            segmentControl.heightAnchor.constraint(equalToConstant: 50),
            segmentControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentControl.rightAnchor.constraint(equalTo: view.rightAnchor)
            
        ])
        
    }
    
    
    // 0 - constrictionParametresView, 1 - supports
    private func configureConstraintsFor(_ num: Int) {
        if num == 0 {
            NSLayoutConstraint.deactivate(supportConstraints)
            NSLayoutConstraint.activate(constructionConstraints)
            supportParametresView?.isHidden = true
            constrictionParametresView?.isHidden = false
            
        } else {
            NSLayoutConstraint.deactivate(constructionConstraints)
            NSLayoutConstraint.activate(supportConstraints)
            constrictionParametresView?.isHidden = true
            supportParametresView?.isHidden = false
        }
    }
}



extension ConstructionConfiguratorVC: SupportParametresViewDelegate {
    func setParametrs(_ parametres: SupportParametres) {
        self.supportParametres = parametres
        constructionView?.configureSupports(self.supportParametres)
    }
}
