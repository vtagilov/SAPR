//
//  RodParametres.swift
//  SAPR
//
//  Created by Владимир on 13.11.2023.
//

import Foundation

struct RodMaterial {
    var elasticModulus: Double
    var permissibleVoltage: Double
}


struct RodParametres {
    var length: Double
    var square: Double
    var material: RodMaterial
    var copiedFrom: Int?
}

struct SupportParametres {
    var isLeftFixed: Bool
    var isRightFixed: Bool
}
