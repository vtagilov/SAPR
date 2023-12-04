//
//  ConstructionParametersView.swift
//  SAPR
//
//  Created by Владимир on 13.11.2023.
//

import UIKit

protocol ConstructionParametersDelegate {
    func setParametrs(_ number: Int, _ RodParameter: RodParametres)
    func deleteLastStick()
    
    func addStick()
    
    func showErrorAlert(message: String)
}

class ConstructionParametersView: UIView {
    
    var rodParameter: RodParametres?
    
    var materials = [RodMaterial]() {
        didSet{
            materialPicker.reloadAllComponents()
        }
    }
    
    var delegate: ConstructionParametersDelegate?
    
    var currentRodNumber = Int()
    
    var rodCount = Int()
    
    let numberOfRod = UILabel()
    let lengthLabel = UILabel()
    let squareLabel = UILabel()
    
    let lengthField = UITextField()
    let squareField = UITextField()
    
    let deleteButton = UIButton()
    let createButton = UIButton()
    
    let materialLabel = UILabel()
    let materialPicker = UIPickerView()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureRod(number: Int, rodParameter: RodParametres) {
        currentRodNumber = number
        self.rodParameter = rodParameter
        
        numberOfRod.text = "Стержень №\(currentRodNumber + 1)"
        lengthField.text = "\(rodParameter.length)"
        squareField.text = "\(rodParameter.square)"
        guard let materialId = rodParameter.materialId else {
            materialPicker.selectRow(0, inComponent: 0, animated: true)
            return
        }
        materialPicker.selectRow(materialId + 1, inComponent: 0, animated: true)
    }

    
    
    private func configureUI() {
        
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.titleLabel?.textAlignment = .right
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        deleteButton.setTitleColor(.lightGray, for: .highlighted)
        
        createButton.setTitle("Добавить", for: .normal)
        createButton.titleLabel?.textAlignment = .left
        createButton.addTarget(self, action: #selector(createButtonAction), for: .touchUpInside)
        createButton.setTitleColor(.systemBlue, for: .normal)
        createButton.setTitleColor(.lightGray, for: .highlighted)
        
        lengthLabel.text = "Длина [L]"
        squareLabel.text = "Площадь поперечного сечения [A]"
        materialLabel.text = "Материал"
        
        
        for label in [squareLabel, lengthLabel, materialLabel] {
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24)
        }
        
        materialPicker.delegate = self
        materialPicker.dataSource = self
        
        numberOfRod.font = .boldSystemFont(ofSize: 24)
        numberOfRod.textAlignment = .center
        numberOfRod.adjustsFontSizeToFitWidth = true
        numberOfRod.adjustsFontForContentSizeCategory = true
        
        for textField in [lengthField, squareField] {
//            textField.keyboardType = .decimalPad
//            textField.returnKeyType = .done
            textField.font = .systemFont(ofSize: 24)
            textField.textAlignment = .center
            textField.backgroundColor = .darkGray
            textField.layer.cornerRadius = 5
            textField.delegate = self
        }
    
        for subView in [squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, materialLabel, materialPicker, createButton] {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    @objc private func deleteButtonAction() {
        if rodCount > 1 {
            rodCount -= 1
            delegate?.deleteLastStick()
        }
    }
    
    
    
    @objc private func createButtonAction() {
        rodCount += 1
        delegate?.addStick()
    }
    
}



// MARK: - Constraints
extension ConstructionParametersView {
    private func setConstraints() {
        
        for subView in [squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, materialLabel, materialPicker, createButton] {
            addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            
            deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            deleteButton.bottomAnchor.constraint(equalTo: numberOfRod.bottomAnchor),
            
            createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            createButton.bottomAnchor.constraint(equalTo: numberOfRod.bottomAnchor),
            
            numberOfRod.topAnchor.constraint(equalTo: topAnchor),
            numberOfRod.leftAnchor.constraint(equalTo: deleteButton.rightAnchor, constant: 20),
            numberOfRod.rightAnchor.constraint(equalTo: createButton.leftAnchor, constant: -20),
            
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
            
            materialLabel.topAnchor.constraint(equalTo: squareField.bottomAnchor, constant: 20),
            materialLabel.leftAnchor.constraint(equalTo: leftAnchor),
            materialLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            materialPicker.topAnchor.constraint(equalTo: materialLabel.bottomAnchor),
            materialPicker.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            materialPicker.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
            
        ])
    }
}



extension ConstructionParametersView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var text = textField.text ?? ""
        text.removeAll(where: { $0 == " " })
        
        if (text.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces)) != nil) {
            delegate?.showErrorAlert(message: "Только чила и точка")
            textField.becomeFirstResponder()
            return
            
        }
        
        let index = text.firstIndex(where: { $0 == ","})
        if index != nil {
            text.remove(at: index!)
            text.insert(".", at: index!)
        }
        textField.text = text
        
        switch textField {
        case lengthField:
            rodParameter?.length = Double((lengthField.text ?? "")) ?? 0.0
        case squareField:
            rodParameter?.square = Double((squareField.text ?? "")) ?? 0.0
        default:
            break
        }
        delegate?.setParametrs(currentRodNumber, rodParameter!)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



extension ConstructionParametersView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return materials.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 { return "Не выбрано" }
        return "\(row)) E = \(materials[row - 1].elasticModulus), σ = \(materials[row - 1].permissibleVoltage)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rodParameter?.materialId = row - 1
        delegate?.setParametrs(currentRodNumber, rodParameter!)
    }
}
