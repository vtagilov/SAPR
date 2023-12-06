//
//  SupportParametresView.swift
//  SAPR
//
//  Created by Владимир on 16.11.2023.
//

import UIKit


protocol SupportParametresViewDelegate {
    func setParametrs(_ parametres: SupportParametres)
}


class SupportParametresView: UIView {
    
    var delegate: SupportParametresViewDelegate?
    
    var supportParametres = SupportParametres(isLeftFixed: false, isRightFixed: false)
    
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    let leftButton = UIButton()
    let rightButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        configureUI()
        setConstraints()
    }
    
    init(delegate: SupportParametresViewDelegate, supportParametres: SupportParametres, size: CGSize) {
        self.delegate = delegate
        self.supportParametres = supportParametres
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func configureUI() {
        leftLabel.text = "Закрепить конструкцию слева"
        rightLabel.text = "Закрепить конструкцию справа"
        
        for button in [leftButton, rightButton] {
            button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        }
        for subview in [leftLabel, leftButton, rightLabel, rightButton] {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    
    
    @objc private func buttonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender == leftButton {
            supportParametres.isLeftFixed = !supportParametres.isLeftFixed
        } else if sender == rightButton {
            supportParametres.isRightFixed = !supportParametres.isRightFixed
        }
        delegate?.setParametrs(supportParametres)
    }

    
}



// MARK: - Constraints
extension SupportParametresView {
    private func setConstraints() {
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            
            leftButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            leftButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            leftButton.heightAnchor.constraint(equalToConstant: 30),
            leftButton.widthAnchor.constraint(equalTo: leftButton.heightAnchor),
            
            leftLabel.leftAnchor.constraint(equalTo: leftButton.rightAnchor, constant: 10),
            leftLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            leftLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            
            rightButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            rightButton.topAnchor.constraint(equalTo: leftButton.bottomAnchor, constant: 30),
            rightButton.heightAnchor.constraint(equalToConstant: 30),
            rightButton.widthAnchor.constraint(equalTo: rightButton.heightAnchor),
            
            rightLabel.leftAnchor.constraint(equalTo: rightButton.rightAnchor, constant: 10),
            rightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            rightLabel.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor)
            
        ])
    }
}

