//
//  UIStick.swift
//  SAPR
//
//  Created by Владимир on 07.11.2023.
//

import UIKit


protocol StickPrametersDelegate {
    func addStickTo(_ direction: Direction)
    func setParameters(_ stick: UIStick, _ tapPoint: CGPoint)
}



class UIStick: UIView {

    var rightStick: UIStick?
    var leftStick: UIStick?
    
    var distributedLoad: DistributedLoad?
    
    let stick = UIView()
    
    let numberLabel = UILabel()
    
    var delegate: StickPrametersDelegate?
    
    var number = 0 {
        didSet {
            numberLabel.text = "\(number + 1)"
        }
    }
    
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    @objc func nodeAction(_ sender: UIButton) {
        delegate?.addStickTo(.right)
    }
    
    @objc private func stickAction(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)
        delegate?.setParameters(self, tapPoint)
    }
    
    
    
    func setDistributedLoad(direction: Direction) {
        if distributedLoad != nil {
            distributedLoad!.removeFromSuperview()
            NSLayoutConstraint.deactivate(distributedLoad!.constraints)
        }
        distributedLoad = DistributedLoad(direction: direction)
        distributedLoad?.translatesAutoresizingMaskIntoConstraints = false
        setDistributedLoadConsraints()
    }
    
    
    
    private func configureUI() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(stickAction))
        self.addGestureRecognizer(tapRecognizer)
        
        self.layer.borderWidth = 2
        
        number = 0
        numberLabel.textColor = .black
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
    }
    
}



extension UIStick {
    private func setConstraints() {
        addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setDistributedLoadConsraints() {
        addSubview(distributedLoad!)
        distributedLoad!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distributedLoad!.leftAnchor.constraint(equalTo: leftAnchor),
            distributedLoad!.rightAnchor.constraint(equalTo: rightAnchor),
            distributedLoad!.topAnchor.constraint(equalTo: topAnchor),
            distributedLoad!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
