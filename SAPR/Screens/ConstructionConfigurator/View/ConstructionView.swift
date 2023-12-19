//
//  ConstructionView.swift
//  SAPR
//
//  Created by Владимир on 31.10.2023.
//

import UIKit

protocol ConstructionViewDelegate {
    func rodWasSelected(_ rod: UIStick)
}



class ConstructionView: UIView {

    var stickCount: Int {
        var c = 1
        var currentStick = self.stick.rightStick
        while currentStick != nil {
            currentStick = currentStick?.rightStick
            c += 1
        }
        return c
    }
    
    let stick = UIStick()
    
    let leftSupport = UISupport(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
    let rightSupport = UISupport(frame: CGRect(x: 0, y: 0, width: 50, height: 100))
    
    let scrollView = UIScrollView()
    let contentView = UIView()
        
    var standartConstraints = [NSLayoutConstraint]()
    var rightStickConstraints = [[NSLayoutConstraint]()]
    var rightSupportConstraints = [NSLayoutConstraint]()
        
    var delegate: ConstructionViewDelegate?
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        stick.delegate = self
        stick.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width, height: 150)
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 5.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        leftSupport.isHidden = true
        leftSupport.translatesAutoresizingMaskIntoConstraints = false

        rightSupport.isHidden = true
        rightSupport.translatesAutoresizingMaskIntoConstraints = false
        rightSupport.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        setConstraints()
    }
    
    
    
    func configureSupports(_ parametres: SupportParametres) {
        leftSupport.isHidden = !parametres.isLeftFixed
        rightSupport.isHidden = !parametres.isRightFixed
        setRightSupportConstraints()
    }
    
    
    func deleteLastStick() {
        scrollView.contentSize.width -= frame.width / 4 - 25
        var stick = stick
        while stick.rightStick?.rightStick != nil {
            stick = stick.rightStick!
        }
        stick.rightStick = nil
        
        NSLayoutConstraint.deactivate(rightStickConstraints.last!)
        rightStickConstraints.removeLast()
        setRightSupportConstraints()
        delegate?.rodWasSelected(stick)
    }
    
}


// MARK: - StickLocationDelegate
extension ConstructionView: StickPrametersDelegate {
    
    @objc func setParameters(_ stick: UIStick, _ tapPoint: CGPoint) {
        delegate?.rodWasSelected(stick)
    }
    
    
    
    func addStickTo(_ direction: Direction) {
        var stick = stick
        let newStick = UIStick()
        newStick.translatesAutoresizingMaskIntoConstraints = false
        newStick.delegate = self
        
        if direction == .left {
            while stick.leftStick != nil {
                stick = stick.leftStick!
            }
            let newStick = UIStick()
            stick.leftStick = newStick
            
        }
        if direction == .right {
            while stick.rightStick != nil {
                stick = stick.rightStick!
            }
            
            stick.rightStick = newStick
            
        }
        
        contentView.addSubview(newStick)
        addConstraintsToNewStick(from: stick, to: newStick, direction: direction)
    }
    
}


// MARK: - Constraints
extension ConstructionView {
    private func setConstraints() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stick)
        contentView.addSubview(leftSupport)
        contentView.addSubview(rightSupport)
        
        standartConstraints = [
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 5000),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            stick.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            stick.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            stick.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stick.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            leftSupport.rightAnchor.constraint(equalTo: stick.leftAnchor, constant: 6),
            leftSupport.centerYAnchor.constraint(equalTo: stick.centerYAnchor),
            leftSupport.heightAnchor.constraint(equalToConstant: 45)
        ]
        
        NSLayoutConstraint.activate(standartConstraints)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    private func addConstraintsToNewStick(from stick: UIStick, to newStick: UIStick, direction: Direction) {
        newStick.number = stick.number + 1
        contentView.addSubview(newStick)
        scrollView.contentSize.width += frame.width / 4 - 25
        if direction == .left {
            
        } else if direction == .right {
            
            rightStickConstraints.append([
                newStick.leftAnchor.constraint(equalTo: stick.rightAnchor, constant: -2),
                newStick.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                newStick.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
                newStick.centerYAnchor.constraint(equalTo: stick.centerYAnchor)
            
            ])
            
            NSLayoutConstraint.activate(rightStickConstraints.last!)
        }
        delegate?.rodWasSelected(newStick)
        setRightSupportConstraints()
    }
    
    
    private func setRightSupportConstraints() {
        var stick = self.stick
        while stick.rightStick != nil {
            stick = stick.rightStick!
        }
        NSLayoutConstraint.deactivate(rightSupportConstraints)
        rightSupportConstraints = [
            rightSupport.rightAnchor.constraint(equalTo: stick.rightAnchor, constant: -6),
            rightSupport.centerYAnchor.constraint(equalTo: stick.centerYAnchor),
            rightSupport.heightAnchor.constraint(equalToConstant: 45)
        ]
        NSLayoutConstraint.activate(rightSupportConstraints)
    }
    
}
