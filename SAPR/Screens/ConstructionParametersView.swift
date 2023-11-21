//
//  ConstructionParametersView.swift
//  SAPR
//
//  Created by Владимир on 13.11.2023.
//

import UIKit

protocol ConstructionParametersDelegate {
    func setParametrs(_ number: Int, _ RodParameter: RodParametres)
    func deleteRod(_ numer: Int)
    func getParametres(_ rodNumber: Int) -> RodParametres
    func showErrorAlert(message: String)
}

class ConstructionParametersView: UIView {
    
    var rodParameter: RodParametres?
    
    var delegate: ConstructionParametersDelegate?
    
    var currentRodNumber = Int()
    
    var rodCount = Int() {
        didSet {
            copyFromPicker.reloadAllComponents()
        }
    }
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let numberOfRod = UILabel()
    let lengthLabel = UILabel()
    let squareLabel = UILabel()
    let elasticModulusLabel = UILabel()
    let permissibleVoltageLabel = UILabel()
    let isCopyLabel = UILabel()
    
    let lengthField = UITextField()
    let squareField = UITextField()
    let elasticModulusField = UITextField()
    let permissibleVoltageField = UITextField()
    
    let isCopyButton = UIButton()
    let deleteButton = UIButton()
    let copyFromPicker = UIPickerView()
    
    
    
    init(_ size: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
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
        elasticModulusField.text = "\(rodParameter.material.elasticModulus)"
        permissibleVoltageField.text = "\(rodParameter.material.permissibleVoltage)"
    }

    
    private func configureUI() {
        scrollView.contentSize = CGSize(width: frame.width, height: 600)
        deleteButton.setTitle("Удалить", for: .normal)
        deleteButton.titleLabel?.textAlignment = .right
        deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        deleteButton.setTitleColor(.systemBlue, for: .normal)
        
        isCopyButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        isCopyButton.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        isCopyButton.addTarget(self, action: #selector(copyButtonAction), for: .touchUpInside)
        
        lengthLabel.text = "Длина [L]"
        squareLabel.text = "Площадь поперечного сечения [A]"
        elasticModulusLabel.text = "Модуль упругости [E]"
        permissibleVoltageLabel.text = "Допускаемое напряжение [σ]"
        isCopyLabel.text = "Cкопировать материал из "
        
        for label in [squareLabel, lengthLabel, elasticModulusLabel, permissibleVoltageLabel, isCopyLabel] {
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24)
        }
        
        isCopyLabel.adjustsFontSizeToFitWidth = true
        isCopyLabel.adjustsFontForContentSizeCategory = true
        copyFromPicker.delegate = self
        copyFromPicker.dataSource = self
        
        numberOfRod.font = .boldSystemFont(ofSize: 32)
        
        for textField in [lengthField, squareField, permissibleVoltageField, elasticModulusField] {
//            textField.keyboardType = .decimalPad
//            textField.returnKeyType = .done
            textField.font = .systemFont(ofSize: 24)
            textField.textAlignment = .center
            textField.backgroundColor = .darkGray
            textField.layer.cornerRadius = 5
            textField.delegate = self
        }
    
        for subView in [scrollView, contentView, squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, elasticModulusLabel, permissibleVoltageLabel, isCopyLabel, elasticModulusField, permissibleVoltageField, isCopyLabel, isCopyButton, copyFromPicker] {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    @objc private func deleteButtonAction() {
        print("deleteButtonAction")
    }
    
    
    
    @objc private func copyButtonAction() {
        print("copyButtonAction")
        isCopyButton.isSelected = !isCopyButton.isSelected
        
        elasticModulusField.isEnabled = !isCopyButton.isSelected
        permissibleVoltageField.isEnabled = !isCopyButton.isSelected
        
        if isCopyButton.isSelected {
            var newParametres = delegate?.getParametres(copyFromPicker.selectedRow(inComponent: 0))
            
            newParametres?.copiedFrom = copyFromPicker.selectedRow(inComponent: 0)
            delegate?.setParametrs(currentRodNumber, newParametres!)
            
            elasticModulusField.text = "\(newParametres!.material.elasticModulus)"
            permissibleVoltageField.text = "\(newParametres!.material.permissibleVoltage)"
        } else {
            rodParameter?.copiedFrom = nil
        }
    }

    
}



// MARK: - Constraints
extension ConstructionParametersView {
    private func setConstraints() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        for subView in [squareLabel, lengthLabel, numberOfRod, lengthField, squareField, deleteButton, elasticModulusField, elasticModulusLabel, permissibleVoltageField, permissibleVoltageLabel, isCopyLabel, isCopyButton, copyFromPicker] {
            contentView.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: isCopyButton.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            
            numberOfRod.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberOfRod.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            numberOfRod.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100),
            
            deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            deleteButton.leftAnchor.constraint(equalTo: contentView.rightAnchor, constant: -100),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: numberOfRod.bottomAnchor),
            
            lengthLabel.topAnchor.constraint(equalTo: numberOfRod.bottomAnchor, constant: 10),
            lengthLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            lengthLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            lengthField.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 5),
            lengthField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            lengthField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            squareLabel.topAnchor.constraint(equalTo: lengthField.bottomAnchor, constant: 20),
            squareLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            squareLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            squareField.topAnchor.constraint(equalTo: squareLabel.bottomAnchor, constant: 5),
            squareField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            squareField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            elasticModulusLabel.topAnchor.constraint(equalTo: squareField.bottomAnchor, constant: 40),
            elasticModulusLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            elasticModulusLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            elasticModulusField.topAnchor.constraint(equalTo: elasticModulusLabel.bottomAnchor, constant: 5),
            elasticModulusField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            elasticModulusField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            permissibleVoltageLabel.topAnchor.constraint(equalTo: elasticModulusField.bottomAnchor, constant: 20),
            permissibleVoltageLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            permissibleVoltageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            permissibleVoltageField.topAnchor.constraint(equalTo: permissibleVoltageLabel.bottomAnchor, constant: 5),
            permissibleVoltageField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            permissibleVoltageField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            
            copyFromPicker.topAnchor.constraint(equalTo: permissibleVoltageField.bottomAnchor),
            copyFromPicker.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            copyFromPicker.widthAnchor.constraint(equalToConstant: 100),
            copyFromPicker.heightAnchor.constraint(equalToConstant: 150),
            
            isCopyButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            isCopyButton.centerYAnchor.constraint(equalTo: copyFromPicker.centerYAnchor),
            isCopyButton.heightAnchor.constraint(equalToConstant: 30),
            isCopyButton.widthAnchor.constraint(equalTo: isCopyButton.heightAnchor),
            
            isCopyLabel.leftAnchor.constraint(equalTo: isCopyButton.rightAnchor, constant: 10),
            isCopyLabel.rightAnchor.constraint(equalTo: copyFromPicker.leftAnchor, constant: -10),
            isCopyLabel.centerYAnchor.constraint(equalTo: isCopyButton.centerYAnchor),
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
        case elasticModulusField:
            rodParameter?.material.elasticModulus = Double((elasticModulusField.text ?? "")) ?? 0.0
        case permissibleVoltageField:
            rodParameter?.material.permissibleVoltage = Double((permissibleVoltageField.text ?? "")) ?? 0.0
        default:
            break
        }
        delegate?.setParametrs(currentRodNumber, rodParameter!)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(CGPoint(x: 0, y: 500), animated: true)
        return true
    }
}



extension ConstructionParametersView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { rodCount - 1 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row >= currentRodNumber {
            return "\(row + 2)"
        }
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected \(row + 1)")
    }
}
