//
//  LoadsConfiguratorView.swift
//  SAPR
//
//  Created by Владимир on 27.11.2023.
//

import UIKit


protocol LoadsConfiguratorViewDelegate {
    func showErrorAlert(message: String)
    func setParametres(focusedPower: Double)
    func setParametres(distributedPower: Double)
    func setPowerType(isFocused: Bool)
}



class LoadsConfiguratorView: UIView {

    var delegate: LoadsConfiguratorViewDelegate?
    
    let loadsTypeSegmentControl = UISegmentedControl()
    
    var focusedLoadsConstraints = [NSLayoutConstraint]()
    var distributedLoadsConstraints = [NSLayoutConstraint]()
    
    let focusedPowerField = UITextField()
    let distributedPowerField = UITextField()
    
    let distributedPowerLabel = UILabel()
    let focusedPowerLabel = UILabel()
    
    let createButton = UIButton()
    let deleteButton = UIButton()
    
    
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        
        loadsTypeSegmentControl.insertSegment(withTitle: "Сосредоточенные", at: 0, animated: false)
        loadsTypeSegmentControl.insertSegment(withTitle: "Распределенные", at: 1, animated: false)
        loadsTypeSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        
        
        distributedPowerLabel.text = "cила "
        focusedPowerLabel.text = "сила "
        
        for textField in [distributedPowerField, focusedPowerField] {
//            textField.keyboardType = .decimalPad
//            textField.returnKeyType = .done
            textField.text = "1.0"
            textField.font = .systemFont(ofSize: 24)
            textField.textAlignment = .center
            textField.backgroundColor = .darkGray
            textField.layer.cornerRadius = 5
            textField.delegate = self
        }
        
        setConstraints()
        
        loadsTypeSegmentControl.selectedSegmentIndex = 0
        segmentControlValueChanged()
    }
    
    
    
    @objc private func segmentControlValueChanged() {
        delegate?.setPowerType(isFocused: loadsTypeSegmentControl.selectedSegmentIndex == 0)
        if loadsTypeSegmentControl.selectedSegmentIndex == 0 {
            distributedPowerField.isHidden = true
            focusedPowerField.isHidden = false
            NSLayoutConstraint.deactivate(distributedLoadsConstraints)
            NSLayoutConstraint.activate(focusedLoadsConstraints)
        } else {
            focusedPowerField.isHidden = true
            distributedPowerField.isHidden = false
            NSLayoutConstraint.deactivate(focusedLoadsConstraints)
            NSLayoutConstraint.activate(distributedLoadsConstraints)
        }
        
    }
    
    
    @objc private func createButtonAction() {
//        delegate?.loadsConfiguratorView(segmentControl: sender)
    }
    
    @objc private func deleteButtonAction() {
//        delegate?.loadsConfiguratorView(segmentControl: sender)
    }
    
}



extension LoadsConfiguratorView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var text = textField.text ?? ""
        text.removeAll(where: { $0 == " " })
        
        if (text.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces)) != nil) {
            textField.text = "0.0"
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
        case focusedPowerField:
            delegate?.setParametres(focusedPower: Double((focusedPowerField.text ?? "")) ?? 0.0)
        case distributedPowerField:
            delegate?.setParametres(distributedPower: Double((distributedPowerField.text ?? "")) ?? 0.0)
        default:
            break
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}




extension LoadsConfiguratorView {
    private func setConstraints() {
        
        for subview in [loadsTypeSegmentControl, deleteButton, createButton, focusedPowerLabel, focusedPowerField, distributedPowerField] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            
            loadsTypeSegmentControl.topAnchor.constraint(equalTo: topAnchor),
            loadsTypeSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            loadsTypeSegmentControl.leftAnchor.constraint(equalTo: leftAnchor),
            loadsTypeSegmentControl.rightAnchor.constraint(equalTo: rightAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: loadsTypeSegmentControl.bottomAnchor, constant: 10),
            deleteButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            
            createButton.topAnchor.constraint(equalTo: loadsTypeSegmentControl.bottomAnchor, constant: 10),
            createButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            focusedPowerLabel.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 30),
            focusedPowerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
        
        focusedLoadsConstraints = [
            focusedPowerField.topAnchor.constraint(equalTo: focusedPowerLabel.bottomAnchor, constant: 30),
            focusedPowerField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            focusedPowerField.rightAnchor.constraint(equalTo: rightAnchor, constant: 10)
        ]
        
        distributedLoadsConstraints = [
            distributedPowerField.topAnchor.constraint(equalTo: focusedPowerLabel.bottomAnchor, constant: 30),
            distributedPowerField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            distributedPowerField.rightAnchor.constraint(equalTo: rightAnchor, constant: 10)
        ]
    }
}
