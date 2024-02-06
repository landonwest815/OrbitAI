//
//  OrbitalSystem.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import Foundation
import SwiftData

@Model
class OrbitalSystem {
    var center: PlanetaryBody
    var selectedLayer: Int
    var orbitals: [OrbitalSystem]?
    
    init(center: PlanetaryBody, orbitals: [OrbitalSystem]? = nil) {
        self.center = center
        self.selectedLayer = 0
        self.orbitals = orbitals
    }
}
