//
//  ConstructionLoadsView.swift
//  SAPR
//
//  Created by Владимир on 27.11.2023.
//

import UIKit

protocol ConstructionLoadsViewDelegate {
    func nodeWasSelected(numOfNode: Int, direction: Direction)
    func rodWasSelected(numOfRod: Int)
}

class ConstructionLoadsView: ConstructionView {
    
    var constructionLoadsViewDelegate: ConstructionLoadsViewDelegate?
    
    var focusedLoads = [FocusedLoad]()
    var distributedLoads = [DistributedLoad]()
    
    var nodes = [UIView]()
    
    var nodeConstraints = [NSLayoutConstraint]()
    
    var selectedRod = 0
    var selectedNode = 0
    
    var isFocusedPower = true
    
    
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setPowerType(isFocused: Bool) {
        isFocusedPower = isFocused
        if isFocused {
            setNodePoints()
            sticksHandler { stick in
                stick.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            removeNodePoints()
            
        }
    }
    
    
    func removeAllRods() {
        var rightStick = stick.rightStick
        var preRightStick: UIStick? = stick
        while stick.rightStick != nil {
            rightStick = stick.rightStick
            preRightStick = stick
            while rightStick?.rightStick != nil {
                rightStick = rightStick?.rightStick
                preRightStick = preRightStick?.rightStick
            }
            preRightStick?.rightStick?.removeFromSuperview()
            preRightStick?.rightStick = nil
        }
    }
    
    
    func setDistributedLoad(numOfRod: Int, power: Double) {
        if power == 0.0 { return }
        
        var currentStick = self.stick
        var numOfRod = numOfRod
        while numOfRod != 0 {
            currentStick = currentStick.rightStick!
            numOfRod -= 1
        }
        currentStick.setDistributedLoad(direction: power > 0 ? .right : .left)
    }
    
    
    func setFocusedLoad(numOfNode: Int, power: Double) {
        if power == 0.0 { return }
        let focusedLoad = FocusedLoad()
        focusedLoad.translatesAutoresizingMaskIntoConstraints = false
        addSubview(focusedLoad)
        
        while focusedLoads.count <= numOfNode { focusedLoads.append(FocusedLoad()) }
        focusedLoads[numOfNode].removeFromSuperview()
        focusedLoads[numOfNode] = focusedLoad
        
        var numOfNode = numOfNode
        var stick = stick
        if numOfNode == 0 {
            if power > 0 {
                focusedLoad.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                NSLayoutConstraint.activate([
                    stick.leftAnchor.constraint(equalTo: focusedLoad.leftAnchor, constant: -10),
                    stick.centerYAnchor.constraint(equalTo: focusedLoad.centerYAnchor)
                ])
            } else {
                focusedLoad.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                NSLayoutConstraint.activate([
                    stick.leftAnchor.constraint(equalTo: focusedLoad.leftAnchor, constant: 10),
                    stick.centerYAnchor.constraint(equalTo: focusedLoad.centerYAnchor)
                ])
            }
        } else {
            numOfNode -= 1
            while numOfNode != 0 {
                stick = stick.rightStick!
                numOfNode -= 1
            }
            
            if power > 0 {
                focusedLoad.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
                NSLayoutConstraint.activate([
                    stick.rightAnchor.constraint(equalTo: focusedLoad.leftAnchor, constant: -10),
                    stick.centerYAnchor.constraint(equalTo: focusedLoad.centerYAnchor)
                ])
            } else {
                focusedLoad.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
                NSLayoutConstraint.activate([
                    stick.rightAnchor.constraint(equalTo: focusedLoad.leftAnchor, constant: 10),
                    stick.centerYAnchor.constraint(equalTo: focusedLoad.centerYAnchor)
                ])
            }
        }
    }
    
    
    func removeNodePoints() {
        NSLayoutConstraint.deactivate(nodeConstraints)
        nodeConstraints = []
        nodes.forEach { $0.removeFromSuperview() }
        nodes = []
    }
    
    
    func setNodePoints() {
        var stick: UIStick? = stick
        removeNodePoints()
        while stick != nil {
            let node = UIView()
            nodes.append(node)
            node.layer.cornerRadius = 8
            node.backgroundColor = .black
            
            nodeConstraints.append(node.centerYAnchor.constraint(equalTo: stick!.centerYAnchor))
            nodeConstraints.append(node.centerXAnchor.constraint(equalTo: stick!.leftAnchor))
            nodeConstraints.append(node.widthAnchor.constraint(equalToConstant: 16))
            nodeConstraints.append(node.heightAnchor.constraint(equalToConstant: 16))
            addSubview(node)
            node.translatesAutoresizingMaskIntoConstraints = false
            if stick!.rightStick == nil {
                break
            }
            stick = stick!.rightStick
            
        }
        
        let node = UIView()
        nodes.append(node)
        node.layer.cornerRadius = 8
        node.backgroundColor = .black
        
        nodeConstraints.append(node.centerYAnchor.constraint(equalTo: stick!.centerYAnchor))
        nodeConstraints.append(node.centerXAnchor.constraint(equalTo: stick!.rightAnchor))
        nodeConstraints.append(node.widthAnchor.constraint(equalToConstant: 16))
        nodeConstraints.append(node.heightAnchor.constraint(equalToConstant: 16))
        addSubview(node)
        node.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(nodeConstraints)
        
        nodes[0].backgroundColor = .red
    }
    
    
    
    private func sticksHandler(handle: (UIStick) -> Void) {
        var currentStick = self.stick
        while currentStick.rightStick != nil {
            handle(currentStick)
            currentStick = currentStick.rightStick!
        }
        handle(currentStick)
    }
    
    
    private func getStickNum(stick: UIStick) -> Int {
        var c = 0
        var currentStick = self.stick
        while currentStick != stick {
            c += 1
            currentStick = currentStick.rightStick!
        }
        return c
    }
    
    
    override func setParameters(_ stick: UIStick, _ tapPoint: CGPoint) {
        let stickNum = getStickNum(stick: stick)
        if isFocusedPower {
            selectedNode = tapPoint.x > 50 ? stickNum + 1 : stickNum
            nodes.forEach({$0.backgroundColor = .black})
            nodes[selectedNode].backgroundColor = .red
            constructionLoadsViewDelegate?.nodeWasSelected(numOfNode: selectedNode, direction: tapPoint.x < 50 ? .left : .right)
        } else {
            sticksHandler(handle: { $0.layer.borderColor = UIColor.black.cgColor })
            stick.layer.borderColor = UIColor.red.cgColor
            constructionLoadsViewDelegate?.rodWasSelected(numOfRod: selectedNode)
        }
    }
}
