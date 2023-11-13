//
//  ConstructionParametersView.swift
//  SAPR
//
//  Created by Владимир on 13.11.2023.
//

import UIKit

protocol ConstructionParametersDelegate {
    func setParametrs(_ rodParametres: RodParametres)
    func deleteRod(_ numer: Int)
}

class ConstructionParametersView: UIView {
    
    var rodParametres: RodParametres?
    
    let numberOfRod = UILabel()
    
    let deleteButton = UIButton()
    
    let lengthField = UITextField()
    let squareField = UITextField()
    let elasticModulusField = UITextField()
    let permissibleVoltageField = UITextField()
    
    let lengthLabel = UILabel()
    let squareLabel = UILabel()
    let elasticModulusLabel = UILabel()
    let permissibleVoltageLabel = UILabel()
    let isCopyLabel = UILabel()
    
    let isCopyButton = UIButton()
    let copyFromPicker = UIPickerView()
    
    var currentRodNumber = Int()
    
    var delegate: ConstructionViewDelegate?
    
    
    
    init(_ size: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureRod(number: Int, rodParametres: RodParametres) {
        currentRodNumber = number
        self.rodParametres = rodParametres
        
        lengthField.text = "\(rodParametres.length)"
        squareField.text = "\(rodParametres.square)"
        elasticModulusField.text = "\(rodParametres.material.elasticModulus)"
        permissibleVoltageField.text = "\(rodParametres.material.permissibleVoltage)"
    }

    
    private func configureUI() {
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



// MARK: - Constraints
extension ConstructionParametersView {
    private func setConstraints() {
        
        for subView in [squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, elasticModulusField, elasticModulusLabel, permissibleVoltageField, permissibleVoltageLabel] {
            addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            
            numberOfRod.topAnchor.constraint(equalTo: bottomAnchor),
            numberOfRod.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            numberOfRod.rightAnchor.constraint(equalTo: rightAnchor, constant: -100),
            
            deleteButton.rightAnchor.constraint(equalTo: rightAnchor),
            deleteButton.leftAnchor.constraint(equalTo: rightAnchor, constant: -100),
            deleteButton.centerYAnchor.constraint(equalTo: numberOfRod.centerYAnchor),
            
            lengthLabel.topAnchor.constraint(equalTo: numberOfRod.bottomAnchor, constant: 10),
            lengthLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lengthLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            lengthField.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 5),
            lengthField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            lengthField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            squareLabel.topAnchor.constraint(equalTo: lengthField.bottomAnchor, constant: 20),
            squareLabel.leftAnchor.constraint(equalTo: leftAnchor),
            squareLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            squareField.topAnchor.constraint(equalTo: squareLabel.bottomAnchor, constant: 5),
            squareField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            squareField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            elasticModulusLabel.topAnchor.constraint(equalTo: squareField.bottomAnchor, constant: 40),
            elasticModulusLabel.leftAnchor.constraint(equalTo: leftAnchor),
            elasticModulusLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            elasticModulusField.topAnchor.constraint(equalTo: elasticModulusLabel.bottomAnchor, constant: 5),
            elasticModulusField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            elasticModulusField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            permissibleVoltageLabel.topAnchor.constraint(equalTo: elasticModulusField.bottomAnchor, constant: 20),
            permissibleVoltageLabel.leftAnchor.constraint(equalTo: leftAnchor),
            permissibleVoltageLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            permissibleVoltageField.topAnchor.constraint(equalTo: permissibleVoltageLabel.bottomAnchor, constant: 5),
            permissibleVoltageField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            permissibleVoltageField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                
            
        ])
    }
}



extension ConstructionParametersView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case lengthField:
            rodParametres?.length = Double((lengthField.text ?? "")) ?? 0.0
        case squareField:
            rodParametres?.length = Double((squareField.text ?? "")) ?? 0.0
        case elasticModulusField:
            rodParametres?.length = Double((elasticModulusField.text ?? "")) ?? 0.0
        case permissibleVoltageField:
            rodParametres?.length = Double((permissibleVoltageField.text ?? "")) ?? 0.0
        default:
            break
        }
//        delegate parameters updated
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
