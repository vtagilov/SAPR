//
//  StickParametersTableViewCell.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit

class StickParametersTableViewCell: UITableViewCell {

    static let identifier = "StickParametersTableViewCell"
    
    var numberOfStick: Int?
    var countOfAllSticks: Int?
    
    let numberLabel = UILabel()
    let leftConnectionPickerView = UIPickerView()
    let rightConnectionPickerView = UIPickerView()

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func configureCell(_ numberOfStick: Int, _ countOfAllSticks: Int) {
        self.numberOfStick = numberOfStick
        self.countOfAllSticks = countOfAllSticks
        
        numberLabel.text = "\(numberOfStick))"
        numberLabel.font = .boldSystemFont(ofSize: 24)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftConnectionPickerView.delegate = self
        leftConnectionPickerView.dataSource = self
        leftConnectionPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        rightConnectionPickerView.delegate = self
        rightConnectionPickerView.dataSource = self
        rightConnectionPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
}



// MARK: - Constraints
extension StickParametersTableViewCell {
    private func setConstraints() {
        
        contentView.addSubview(leftConnectionPickerView)
        contentView.addSubview(rightConnectionPickerView)
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            
            numberLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            leftConnectionPickerView.leftAnchor.constraint(equalTo: numberLabel.rightAnchor, constant: 25),
            leftConnectionPickerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftConnectionPickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftConnectionPickerView.widthAnchor.constraint(equalToConstant: 100),
            
            rightConnectionPickerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25),
            rightConnectionPickerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightConnectionPickerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightConnectionPickerView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
}



// MARK: - UIPickerView Extensions
extension StickParametersTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countOfAllSticks!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == numberOfStick! - 1 {
            return "None"
        }
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedNumber = row + 1
        if pickerView === leftConnectionPickerView {
            print("Выбранное число left: \(selectedNumber)")
        }
        if pickerView === rightConnectionPickerView {
            print("Выбранное число right: \(selectedNumber)")
        }
    }
}
