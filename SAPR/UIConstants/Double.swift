//
//  Double.swift
//  SAPR
//
//  Created by Владимир on 19.12.2023.
//

import Foundation

extension Double {
    func getRounded(_ numsAfterPoint: Int) -> Double {
        let multiplayer: Double = pow(10, Double(numsAfterPoint))
        return Double(Int(self * multiplayer)) / multiplayer
    }
}
