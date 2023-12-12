//
//  UILabel.swift
//  SAPR
//
//  Created by Владимир on 06.12.2023.
//

import Foundation
import UIKit


extension UILabel {
    static func makeLabel(title: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }
}
