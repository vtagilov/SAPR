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
    var leftFocusedLoad: FocusedLoad?
    var rightFocusedLoad: FocusedLoad?
    
    let stick = UIView()
    let leftNode = UIView()
    let rightNode = UIView()
    
    
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
    
    
    
//    func setFocusedLoad() {
//        if focusedLoad != nil {
//            distributedLoad!.removeFromSuperview()
//            NSLayoutConstraint.deactivate(distributedLoad!.constraints)
//        }
//        distributedLoad = DistributedLoad(direction: direction)
//        distributedLoad?.translatesAutoresizingMaskIntoConstraints = false
//        setDistributedLoadConsraints()
//    }
    
    
    func setDistributedLoad(direction: Direction) {
        removeDistributedLoad()
        distributedLoad = DistributedLoad(direction: direction)
        distributedLoad?.translatesAutoresizingMaskIntoConstraints = false
        setDistributedLoadConsraints()
    }
    
    
    func removeDistributedLoad() {
        guard let distributedLoad = distributedLoad else {
            return
        }
        distributedLoad.removeFromSuperview()
        NSLayoutConstraint.deactivate(distributedLoad.constraints)
        self.distributedLoad = nil
    }
    
    
    func setFocusedLoad(node: Direction, direction: Direction) {
        if node == .left {
            removeFocusedLoad(node: .left)
            leftFocusedLoad = FocusedLoad(direction: direction)
        } else {
            removeFocusedLoad(node: .right)
            rightFocusedLoad = FocusedLoad(direction: direction)
        }
        setFocusedLoadConsraints(nodeDirection: node, direction: direction)
    }
    
    
    func removeFocusedLoad(node: Direction) {
        if node == .left {
            if leftFocusedLoad != nil {
                leftFocusedLoad!.removeFromSuperview()
                NSLayoutConstraint.deactivate(leftFocusedLoad!.constraints)
                self.leftFocusedLoad = nil
            }
        } else {
            if rightFocusedLoad != nil {
                rightFocusedLoad!.removeFromSuperview()
                NSLayoutConstraint.deactivate(rightFocusedLoad!.constraints)
                self.rightFocusedLoad = nil
            }
        }
    }
    
    
    private func configureUI() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(stickAction))
        self.addGestureRecognizer(tapRecognizer)
        
        self.layer.borderWidth = 2
        
        number = 0
        numberLabel.textColor = .black
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setConstraints()
        configureNodes()
    }
    
    
    private func configureNodes() {
        for node in [rightNode, leftNode] {
            node.backgroundColor = .black
            node.isHidden = true
            node.layer.cornerRadius = 6
        }
        setNodesConsraints()
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
    
    private func setFocusedLoadConsraints(nodeDirection: Direction, direction: Direction) {
        var node: UIView
        var load: FocusedLoad
        if nodeDirection == .left {
            node = leftNode
            load = leftFocusedLoad!
        } else {
            node = rightNode
            load = rightFocusedLoad!
        }
        addSubview(load)
        load.translatesAutoresizingMaskIntoConstraints = false
        if direction == .right {
            NSLayoutConstraint.activate([
                node.centerYAnchor.constraint(equalTo: load.centerYAnchor),
                load.leftAnchor.constraint(equalTo: node.centerXAnchor, constant: 10)
            ])
        } else if direction == .left {
            NSLayoutConstraint.activate([
                node.centerYAnchor.constraint(equalTo: load.centerYAnchor),
                load.rightAnchor.constraint(equalTo: node.centerXAnchor, constant: -10)
            ])
        }
        
    }
    
    private func setNodesConsraints() {
        addSubview(leftNode)
        addSubview(rightNode)
        leftNode.translatesAutoresizingMaskIntoConstraints = false
        rightNode.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftNode.centerXAnchor.constraint(equalTo: leftAnchor),
            leftNode.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftNode.widthAnchor.constraint(equalToConstant: 12),
            leftNode.heightAnchor.constraint(equalTo: leftNode.widthAnchor),
            
            rightNode.centerXAnchor.constraint(equalTo: rightAnchor),
            rightNode.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightNode.widthAnchor.constraint(equalToConstant: 12),
            rightNode.heightAnchor.constraint(equalTo: rightNode.widthAnchor),
        ])
    }
}
