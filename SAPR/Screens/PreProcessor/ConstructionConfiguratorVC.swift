//
//  NodeConfiguratorViewController.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class ConstructionConfiguratorVC: UIViewController {

    var rodParametres = [RodParametres]()
    
    var constructionView: ConstructionView?
    
    var constrictionParametresView: ConstructionParametersView?
    
    let numberOfRod = UILabel()
    
    let deleteButton = UIButton()
    
    let lengthField = UITextField()
    let squareField = UITextField()
    
    let lengthLabel = UILabel()
    let squareLabel = UILabel()
    
    let elasticModulusLabel = UILabel()
    let permissibleVoltageLabel = UILabel()
    
    let elasticModulusField = UITextField()
    let permissibleVoltageField = UITextField()
    
    let isCopyLabel = UILabel()
    let isCopyButton = UIButton()
    let copyFromPicker = UIPickerView()
    
    var currentRodNumber = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Конструкция"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        constructionView = ConstructionView(CGSize(width: view.frame.width, height: 200))
        constructionView?.delegate = self
        constructionView?.delegate?.setParametrs(constructionView!.stick)
        
        constrictionParametresView = ConstructionParametersView(CGSize(width: view.frame.width, height: 200))
        constrictionParametresView?.delegate = self
        
        configureUI()
        setConstraints()
    }
    
    

    private func configureUI() {
        constructionView?.translatesAutoresizingMaskIntoConstraints = false
        constrictionParametresView?.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.titleLabel?.textAlignment = .right
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        
        lengthLabel.text = "Длина [L]"
        squareLabel.text = "Площадь поперечного сечения [A]"
        elasticModulusLabel.text = "Модуль упругости [E]"
        permissibleVoltageLabel.text = "Допускаемое напряжение [σ]"
        isCopyLabel.text = "Cкопировать материал из "
        
        for label in [squareLabel, lengthLabel, elasticModulusLabel, permissibleVoltageLabel, isCopyLabel] {
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24)
        }
        
        
        numberOfRod.font = .boldSystemFont(ofSize: 32)
//        numberOfRod.textAlignment = .left
        
        for textField in [lengthField, squareField, permissibleVoltageField, elasticModulusField] {
            textField.keyboardType = .decimalPad
            textField.returnKeyType = .done
            textField.font = .systemFont(ofSize: 24)
            textField.textAlignment = .center
            textField.backgroundColor = .darkGray
            textField.layer.cornerRadius = 5
            textField.delegate = self
        }
    
        
        
        for subView in [squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, elasticModulusLabel, permissibleVoltageLabel, isCopyLabel, elasticModulusField, permissibleVoltageField] {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    @objc private func deleteButtonAction() {
        print("deleteButtonAction")
    }

}



extension ConstructionConfiguratorVC: ConstructionViewDelegate {
    func setParametrs(_ rod: UIStick) {
        currentRodNumber = rod.number
        numberOfRod.text = "Стержень №\(currentRodNumber + 1)"
        if rod.number >= rodParametres.count {
            lengthField.text = "1.0"
            squareField.text = "1.0"
            permissibleVoltageField.text = "1.0"
            elasticModulusField.text = "1.0"
            rodParametres.append(RodParametres(length: Double(lengthField.text!)!, square: Double(squareField.text!)!, material: RodMaterial(elasticModulus: 1.0, permissibleVoltage: 1.0)))
        } else {
            lengthField.text = String(rodParametres[currentRodNumber].length)
            squareField.text = String(rodParametres[currentRodNumber].square)
        }
    }
    
    
}


// MARK: - Constraints
extension ConstructionConfiguratorVC {
    private func setConstraints() {
        
        for subView in [constructionView!, squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, elasticModulusField, elasticModulusLabel, permissibleVoltageField, permissibleVoltageLabel] {
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            
            constructionView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            constructionView!.heightAnchor.constraint(equalToConstant: 200),
            constructionView!.leftAnchor.constraint(equalTo: view.leftAnchor),
            constructionView!.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            numberOfRod.topAnchor.constraint(equalTo: constructionView!.bottomAnchor, constant: 20),
            numberOfRod.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            numberOfRod.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            
            deleteButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            deleteButton.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
            deleteButton.centerYAnchor.constraint(equalTo: numberOfRod.centerYAnchor),
            
            lengthLabel.topAnchor.constraint(equalTo: numberOfRod.bottomAnchor, constant: 10),
            lengthLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            lengthLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            lengthField.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 5),
            lengthField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            lengthField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            squareLabel.topAnchor.constraint(equalTo: lengthField.bottomAnchor, constant: 20),
            squareLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            squareLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            squareField.topAnchor.constraint(equalTo: squareLabel.bottomAnchor, constant: 5),
            squareField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            squareField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            elasticModulusLabel.topAnchor.constraint(equalTo: squareField.bottomAnchor, constant: 40),
            elasticModulusLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            elasticModulusLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            elasticModulusField.topAnchor.constraint(equalTo: elasticModulusLabel.bottomAnchor, constant: 5),
            elasticModulusField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            elasticModulusField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            permissibleVoltageLabel.topAnchor.constraint(equalTo: elasticModulusField.bottomAnchor, constant: 20),
            permissibleVoltageLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            permissibleVoltageLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            permissibleVoltageField.topAnchor.constraint(equalTo: permissibleVoltageLabel.bottomAnchor, constant: 5),
            permissibleVoltageField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            permissibleVoltageField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                
            
        ])
    }
}



extension ConstructionConfiguratorVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        rodParametres[currentRodNumber] = RodParametres(length: Double(lengthField.text!)!, square: Double(squareField.text!)!, material: RodMaterial(elasticModulus: 1.0, permissibleVoltage: 1.0))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
