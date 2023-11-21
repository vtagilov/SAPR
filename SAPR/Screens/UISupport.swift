//
//  Support.swift
//  SAPR
//
//  Created by Владимир on 16.11.2023.
//

import UIKit

class UISupport: UIView {

    let bigView = UIView()
    
    var smallViews = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFirstView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFirstView() {
        bigView.backgroundColor = .black
        bigView.translatesAutoresizingMaskIntoConstraints = false
    }

    
    func setConstraints() {
        
        addSubview(bigView)
        
        NSLayoutConstraint.activate([
            bigView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            bigView.widthAnchor.constraint(equalToConstant: 2),
            bigView.topAnchor.constraint(equalTo: topAnchor),
            bigView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        var lastConstraint = bigView.topAnchor
        
        for i in 0 ..< 7 {
            let view = UIView()
            view.backgroundColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
            addSubview(view)
            if i == 0 {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: lastConstraint),
                    view.widthAnchor.constraint(equalToConstant: 2),
                    view.heightAnchor.constraint(equalToConstant: 10),
                    view.rightAnchor.constraint(equalTo: bigView.leftAnchor, constant: -2)
                ])
                lastConstraint = view.bottomAnchor
                continue
            }
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: lastConstraint, constant: -3),
                view.widthAnchor.constraint(equalToConstant: 2),
                view.heightAnchor.constraint(equalToConstant: 10),
                view.rightAnchor.constraint(equalTo: bigView.leftAnchor, constant: -2)
            ])
            lastConstraint = view.bottomAnchor
        }
        
        
    }
    
}
