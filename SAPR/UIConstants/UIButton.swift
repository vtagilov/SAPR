//
//  UIButton.swift
//  SAPR
//
//  Created by Владимир on 06.12.2023.
//

import Foundation
import UIKit


extension UIButton {
    static func makeButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        return button
    }
}
