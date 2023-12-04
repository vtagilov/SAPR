//
//  TriangleView.swift
//  SAPR
//
//  Created by Владимир on 27.11.2023.
//

import UIKit


class TriangleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTriangleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTriangleView()
    }
    
    private func configureTriangleView() {
        backgroundColor = .clear
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = path.cgPath
        triangleLayer.fillColor = UIColor.red.cgColor
        
        layer.addSublayer(triangleLayer)
        
        triangleLayer.frame = bounds
    }
}
