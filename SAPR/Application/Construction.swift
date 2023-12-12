//
//  Construction.swift
//  SAPR
//
//  Created by Владимир on 12.12.2023.
//

import Foundation

struct Construction {
    var name: String?
    var supportParametres: SupportParametres
    var rodParametres: [RodParametres]
    var rodMaterials: [RodMaterial]
    var focusedLoads: [Double]
    var distributedLoads: [Double]
}
