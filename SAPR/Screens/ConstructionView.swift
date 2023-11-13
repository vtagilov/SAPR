//
//  ConstructionView.swift
//  SAPR
//
//  Created by Владимир on 31.10.2023.
//

import UIKit

protocol ConstructionViewDelegate {
    func setParametrs(_ rod: UIStick)
}



class ConstructionView: UIView {

    let stick = UIStick()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var standartConstraints = [NSLayoutConstraint]()
        
    var delegate: ConstructionViewDelegate?
    
    
    
    init(_ frame: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureUI() {
        
        stick.delegate = self
        stick.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.contentSize = CGSize(width: frame.width, height: 200)
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 5.0
//        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .blue
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = .red
        
        setConstraints()
        
    }
    
}





// MARK: - Constraints
extension ConstructionView {
    private func setConstraints() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stick)
        
        standartConstraints = [
            contentView.widthAnchor.constraint(greaterThanOrEqualToConstant: 5000),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            stick.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width / 4),
            stick.heightAnchor.constraint(greaterThanOrEqualToConstant: frame.height / 10),
            stick.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stick.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
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
        print(newStick.number)
        contentView.addSubview(newStick)
        scrollView.contentSize.width += frame.width / 4 - 25
        if direction == .left {
            
        } else if direction == .right {
            NSLayoutConstraint.activate([
                newStick.leftAnchor.constraint(equalTo: stick.rightAnchor, constant: -25),
                newStick.widthAnchor.constraint(greaterThanOrEqualToConstant: frame.width / 4),
                newStick.heightAnchor.constraint(greaterThanOrEqualToConstant: frame.height / 10),
                newStick.centerYAnchor.constraint(equalTo: stick.centerYAnchor)
            ])
        }
        delegate?.setParametrs(newStick)
    }
    
}



// MARK: - StickLocationDelegate
extension ConstructionView: StickPrametersDelegate {
    
    func setParameters(_ stick: UIStick) {
        delegate?.setParametrs(stick)
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



// MARK: - UIScrollViewDelegate
//extension ConstructionView: UIScrollViewDelegate {
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return contentView
//    }
//}
