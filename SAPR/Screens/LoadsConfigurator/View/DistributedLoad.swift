//
//  DistributedLoa.swift
//  SAPR
//
//  Created by Владимир on 04.12.2023.
//

import UIKit

class DistributedLoad: UIView {
    
    let focusedLoads = [FocusedLoad(), FocusedLoad(), FocusedLoad(), FocusedLoad()]
        
    
    init(direction: Direction) {
        super.init(frame: .zero)
        configureUI(direction: direction)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI(direction: Direction) {
        focusedLoads.forEach({
            $0.configureForDistributed()
            $0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            $0.transform = CGAffineTransform(rotationAngle: direction == .right ? CGFloat.pi / 2 : -CGFloat.pi / 2)
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            })
    }
    
}



extension DistributedLoad {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            focusedLoads[0].leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            focusedLoads[0].centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        for i in 0 ... 2 {
            let leftLoad = focusedLoads[i]
            let rightLoad = focusedLoads[i+1]
            
            NSLayoutConstraint.activate([
                rightLoad.leftAnchor.constraint(equalTo: leftLoad.rightAnchor, constant: 27),
                rightLoad.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
}
