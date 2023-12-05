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
    
    let powerLabel = UILabel()
    
    
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
    
    private func configureUI() {
        loadsTypeSegmentControl.insertSegment(withTitle: "Сосредоточенные", at: 0, animated: false)
        loadsTypeSegmentControl.insertSegment(withTitle: "Распределенные", at: 1, animated: false)
        loadsTypeSegmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        
        
        powerLabel.text = "Сосредоточенная сила на узле №1"
        
        for textField in [distributedPowerField, focusedPowerField] {
            textField.text = "0.0"
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
        
        for subview in [loadsTypeSegmentControl, powerLabel, focusedPowerField, distributedPowerField] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            
            loadsTypeSegmentControl.topAnchor.constraint(equalTo: topAnchor),
            loadsTypeSegmentControl.heightAnchor.constraint(equalToConstant: 40),
            loadsTypeSegmentControl.leftAnchor.constraint(equalTo: leftAnchor),
            loadsTypeSegmentControl.rightAnchor.constraint(equalTo: rightAnchor),
            
            powerLabel.topAnchor.constraint(equalTo: loadsTypeSegmentControl.bottomAnchor, constant: 100),
            powerLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
        
        focusedLoadsConstraints = [
            focusedPowerField.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 30),
            focusedPowerField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            focusedPowerField.rightAnchor.constraint(equalTo: rightAnchor, constant: 10)
        ]
        
        distributedLoadsConstraints = [
            distributedPowerField.topAnchor.constraint(equalTo: powerLabel.bottomAnchor, constant: 30),
            distributedPowerField.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            distributedPowerField.rightAnchor.constraint(equalTo: rightAnchor, constant: 10)
        ]
    }
}
