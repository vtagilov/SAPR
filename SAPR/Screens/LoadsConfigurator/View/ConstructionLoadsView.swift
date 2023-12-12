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
    
    var isFocusedPower = true
    
    var selectedNode = 0
    var selectedRod = 0
    
    
    override func setParameters(_ stick: UIStick, _ tapPoint: CGPoint) {
        let stickNum = stick.number
        if isFocusedPower {
            selectedNode = tapPoint.x > 50 ? stickNum + 1 : stickNum
            sticksHandler(handle: {
                $0.rightNode.backgroundColor = .black
                $0.leftNode.backgroundColor = .black
            })
            
            if tapPoint.x > 50 {
                stick.rightNode.backgroundColor = .red
                stick.rightStick?.leftNode.backgroundColor = .red
            } else if tapPoint.x < 50 {
                stick.leftNode.backgroundColor = .red
                getPreviousStick(stick: stick)?.rightNode.backgroundColor = .red
            }
            constructionLoadsViewDelegate?.nodeWasSelected(numOfNode: selectedNode, direction: tapPoint.x < 50 ? .left : .right)
        } else {
            selectedRod = stickNum
            sticksHandler(handle: { $0.layer.borderColor = UIColor.black.cgColor })
            stick.layer.borderColor = UIColor.red.cgColor
            constructionLoadsViewDelegate?.rodWasSelected(numOfRod: selectedRod)
        }
    }
    
    
    
    func setPowerType(isFocused: Bool) {
        isFocusedPower = isFocused
        if isFocused {
            sticksHandler { 
                $0.layer.borderColor = UIColor.black.cgColor
                $0.leftNode.backgroundColor = .black
                $0.rightNode.backgroundColor = .black
            }
            selectedNode = 0
            stick.leftNode.backgroundColor = .red
            setNodePoints()
            
        } else {
            selectedRod = 0
            hideNodePoints()
            stick.layer.borderColor = UIColor.red.cgColor
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
        guard let currentStick = getStick(num: numOfRod) else {
            return
        }
        if power == 0.0 {
            currentStick.removeDistributedLoad()
            return
        }
        currentStick.setDistributedLoad(direction: power > 0 ? .right : .left)
    }
    
    
    func setFocusedLoad(numOfNode: Int, power: Double) {
        var currentStick: UIStick
        var node: Direction
        if numOfNode == 0 {
            currentStick = self.stick
            node = .left
        } else {
            guard getStick(num: numOfNode - 1) != nil else {
                return
            }
            currentStick = getStick(num: numOfNode - 1)!
            node = .right
        }
        if power == 0.0 {
            currentStick.removeFocusedLoad(node: node)
            return
        }
        let direction: Direction = power > 0 ? .right : .left
        currentStick.setFocusedLoad(node: node, direction: direction)
    }
    
    
    func setNodePoints() {
        sticksHandler(handle: { 
            $0.rightNode.isHidden = false
            $0.leftNode.isHidden = false
        })
    }
    
    
    func hideNodePoints() {
        sticksHandler(handle: {
            $0.rightNode.isHidden = true
            $0.leftNode.isHidden = true
        })
    }
    
    
    
    private func sticksHandler(handle: (UIStick) -> Void) {
        var currentStick = self.stick
        while currentStick.rightStick != nil {
            handle(currentStick)
            currentStick = currentStick.rightStick!
        }
        handle(currentStick)
    }
    
    
    private func getStick(num: Int) -> UIStick? {
        var currentStick = self.stick
        while currentStick.number != num && currentStick.rightStick != nil {
            currentStick = currentStick.rightStick!
        }
        if currentStick.number == num {
            return currentStick
        }
        return nil
    }
    
    
    private func getPreviousStick(stick: UIStick) -> UIStick? {
        var currentStick = self.stick
        while currentStick.rightStick != stick && currentStick.rightStick != nil {
            currentStick = currentStick.rightStick!
        }
        if currentStick.rightStick == stick {
            return currentStick
        }
        return nil
    }
    
    
    private func findStick(_ handle: (UIStick) -> Bool) -> UIStick? {
        var currentRod = self.stick
        while handle(currentRod) && currentRod.rightStick != nil {
            currentRod = currentRod.rightStick!
        }
        if handle(currentRod) { return currentRod }
        return nil
    }

}
