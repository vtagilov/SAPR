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
    let leftNode = UIButton()
    let rightNode = UIButton()
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
        
        stick.backgroundColor = .gray
        stick.layer.cornerRadius = 10
        stick.translatesAutoresizingMaskIntoConstraints = false
        
        leftNode.backgroundColor = .lightGray
        leftNode.layer.cornerRadius = 10
        leftNode.setImage(UIImage(systemName: "smallcircle.filled.circle"), for: .normal)
        leftNode.tintColor = .black
        leftNode.translatesAutoresizingMaskIntoConstraints = false
        leftNode.addTarget(self, action: #selector(nodeAction), for: .touchUpInside)
        
        rightNode.backgroundColor = .lightGray
        rightNode.layer.cornerRadius = 10
        rightNode.setImage(UIImage(systemName: "plus"), for: .normal)
        rightNode.tintColor = .black
        rightNode.translatesAutoresizingMaskIntoConstraints = false
        rightNode.addTarget(self, action: #selector(nodeAction), for: .touchUpInside)
        
        number = 0
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
    
    @objc func nodeAction(_ sender: UIButton) {
        let direction: Direction = sender == leftNode ? .left : .right
        delegate?.addStickTo(direction)
    }
    
    
    @objc private func stickAction() {
        delegate?.setParameters(self)
    }
    
}



extension UIStick {
    private func setConstraints() {
        
        addSubview(stick)
        addSubview(leftNode)
        addSubview(rightNode)
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            stick.leftAnchor.constraint(equalTo: leftAnchor),
            stick.rightAnchor.constraint(equalTo: rightAnchor),
            stick.topAnchor.constraint(equalTo: topAnchor),
            stick.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            leftNode.topAnchor.constraint(equalTo: stick.topAnchor),
            leftNode.bottomAnchor.constraint(equalTo: stick.bottomAnchor),
            leftNode.leftAnchor.constraint(equalTo: stick.leftAnchor),
            leftNode.widthAnchor.constraint(equalTo: leftNode.heightAnchor, multiplier: 1.0),
            
            rightNode.topAnchor.constraint(equalTo: stick.topAnchor),
            rightNode.bottomAnchor.constraint(equalTo: stick.bottomAnchor),
            rightNode.rightAnchor.constraint(equalTo: stick.rightAnchor),
            rightNode.widthAnchor.constraint(equalTo: rightNode.heightAnchor, multiplier: 1.0),
            
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
}
