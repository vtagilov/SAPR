//
//  FocusedLoad.swift
//  SAPR
//
//  Created by Владимир on 27.11.2023.
//

import UIKit

class FocusedLoad: UIView {

    let triangle = UIView()
    var line = UIView()
    
    
    init() {
        super.init(frame: .zero)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureForDistributed() {
        line.backgroundColor = .blue
        triangle.backgroundColor = .blue
        
        makeTriangle(triangleSize: 7)
        
        NSLayoutConstraint.deactivate(triangle.constraints)
        NSLayoutConstraint.deactivate(line.constraints)
        setDistributedConstraints()
    }
    
    
    private func configureUI() {
        triangle.backgroundColor = .red
        let rotationAngle = CGFloat.pi / 4
        triangle.transform = CGAffineTransform(rotationAngle: rotationAngle)
        makeTriangle(triangleSize: 15)
        line.backgroundColor = .red
    }
    
    private func makeTriangle(triangleSize: CGFloat) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: triangleSize, y: 0))
        path.addLine(to: CGPoint(x: 0, y: triangleSize))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        triangle.layer.mask = maskLayer
    }
    
}



extension FocusedLoad {
    private func setConstraints() {
        for subview in [line, triangle] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
        
        NSLayoutConstraint.activate([
            triangle.topAnchor.constraint(equalTo: topAnchor),
            triangle.heightAnchor.constraint(equalToConstant: 15),
            triangle.centerXAnchor.constraint(equalTo: centerXAnchor),
            triangle.widthAnchor.constraint(equalToConstant: 15),
            
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.topAnchor.constraint(equalTo: topAnchor),
            line.heightAnchor.constraint(equalToConstant: 20),
            line.centerXAnchor.constraint(equalTo: centerXAnchor),
            line.widthAnchor.constraint(equalToConstant: 5),
        ])
    }
    
    private func setDistributedConstraints() {
        NSLayoutConstraint.activate([
            triangle.topAnchor.constraint(equalTo: topAnchor),
            triangle.heightAnchor.constraint(equalToConstant: 7),
            triangle.centerXAnchor.constraint(equalTo: centerXAnchor),
            triangle.widthAnchor.constraint(equalToConstant: 7),
            
            line.bottomAnchor.constraint(equalTo: bottomAnchor),
            line.topAnchor.constraint(equalTo: topAnchor),
            line.heightAnchor.constraint(equalToConstant: 15),
            line.centerXAnchor.constraint(equalTo: centerXAnchor),
            line.widthAnchor.constraint(equalToConstant: 2)
            ])
    }
}
