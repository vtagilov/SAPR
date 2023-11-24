//
//  UIStick.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit


protocol StickPrametersDelegate {
    func addStickTo(_ direction: Direction)
    func setParameters(_ stick: UIStick)
}



class UIStick: UIView {

    var rightStick: UIStick?
    var leftStick: UIStick?
    
    let stick = UIView()
    
    let numberLabel = UILabel()
    
    var number = 0 {
        didSet {
            numberLabel.text = "\(number + 1)"
        }
    }
    
    var delegate: StickPrametersDelegate?
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func configureUI() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(stickAction))
        self.addGestureRecognizer(tapRecognizer)
        
        stick.backgroundColor = .white
        stick.layer.borderWidth = 2
//        stick.layer.borderColor = UIColor.black.cgColor
        stick.translatesAutoresizingMaskIntoConstraints = false
        
        number = 0
        numberLabel.textColor = .black
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    
    @objc func nodeAction(_ sender: UIButton) {
        
        delegate?.addStickTo(.right)
    }
    
    
    @objc private func stickAction() {
        delegate?.setParameters(self)
    }
    
}



extension UIStick {
    private func setConstraints() {
        
        addSubview(stick)
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            stick.leftAnchor.constraint(equalTo: leftAnchor),
            stick.rightAnchor.constraint(equalTo: rightAnchor),
            stick.topAnchor.constraint(equalTo: topAnchor),
            stick.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
}
