//
//  MaterialCell.swift
//  SAPR
//
//  Created by Владимир on 22.11.2023.
//

import UIKit


protocol MaterialCellDelegate {
    func updateMaterial(id: Int, material: RodMaterial)
    func showErrorAlert(message: String)
}




class MaterialCell: UITableViewCell {

    static let reuseIdentifier = "MaterialCell"
    
    var delegate: MaterialCellDelegate?
    
    var material: RodMaterial?
    
    
    let numLabel = UILabel()
    
    let elasticModulusLabel = UILabel()
    let permissibleVoltageLabel = UILabel()
    
    let elasticModulusField = UITextField()
    let permissibleVoltageField = UITextField()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
    func configureCell(delegate: MaterialCellDelegate, id: Int, material: RodMaterial) {
        self.delegate = delegate
        self.material = material
        numLabel.text = "\(id + 1)"
        elasticModulusLabel.text = "E = "
        permissibleVoltageLabel.text = "σ = "
        elasticModulusField.text = "\(material.elasticModulus)"
        permissibleVoltageField.text = "\(material.permissibleVoltage)"
        
        numLabel.font = .systemFont(ofSize: 36)
        permissibleVoltageLabel.font = .systemFont(ofSize: 24)
        elasticModulusLabel.font = .systemFont(ofSize: 24)
        permissibleVoltageField.font = .systemFont(ofSize: 24)
        elasticModulusField.font = .systemFont(ofSize: 24)
        
        permissibleVoltageField.backgroundColor = .darkGray
        permissibleVoltageField.layer.cornerRadius = 5
        permissibleVoltageField.textAlignment = .center
        permissibleVoltageField.delegate = self
        
        elasticModulusField.backgroundColor = .darkGray
        elasticModulusField.layer.cornerRadius = 5
        elasticModulusField.textAlignment = .center
        elasticModulusField.delegate = self
        
        setConstraints()
        
    }
    
}



extension MaterialCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var text = textField.text ?? ""
        text.removeAll(where: { $0 == " " })
        
        if (text.rangeOfCharacter(from: CharacterSet.letters.union(.whitespaces)) != nil) {
            delegate?.showErrorAlert(message: "Только чила и точка")
            textField.text = "1.0"
        }
        
        let index = text.firstIndex(where: { $0 == ","})
        if index != nil {
            text.remove(at: index!)
            text.insert(".", at: index!)
        }
        textField.text = text
        switch textField {
        case permissibleVoltageField:
            material?.permissibleVoltage = Double((permissibleVoltageField.text ?? "")) ?? 0.0
        case elasticModulusField:
            material?.elasticModulus = Double((elasticModulusField.text ?? "")) ?? 0.0
        default:
            break
        }
        delegate?.updateMaterial(id: Int(numLabel.text!)! - 1, material: material!)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
}


extension MaterialCell {
    private func setConstraints() {
        
        for view in [numLabel, permissibleVoltageLabel, elasticModulusLabel, elasticModulusField, permissibleVoltageField] {
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            numLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            numLabel.widthAnchor.constraint(equalToConstant: 50),
            
            elasticModulusLabel.leftAnchor.constraint(equalTo: numLabel.rightAnchor),
            elasticModulusLabel.widthAnchor.constraint(equalToConstant: 50),
            elasticModulusLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            elasticModulusField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            elasticModulusField.leftAnchor.constraint(equalTo: elasticModulusLabel.rightAnchor),
            elasticModulusField.bottomAnchor.constraint(equalTo: elasticModulusLabel.bottomAnchor),
            
            permissibleVoltageLabel.leftAnchor.constraint(equalTo: numLabel.rightAnchor),
            permissibleVoltageLabel.rightAnchor.constraint(equalTo: permissibleVoltageLabel.leftAnchor, constant: 50),
            permissibleVoltageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            permissibleVoltageField.leftAnchor.constraint(equalTo: elasticModulusLabel.rightAnchor),
            permissibleVoltageField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            permissibleVoltageField.bottomAnchor.constraint(equalTo: permissibleVoltageLabel.bottomAnchor),
        ])
        
    }
}

