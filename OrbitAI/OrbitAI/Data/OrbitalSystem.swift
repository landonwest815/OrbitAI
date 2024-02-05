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
    var orbitalPaths: [OrbitalPath]?
    
    init(center: PlanetaryBody, orbitalPaths: [OrbitalPath]? = nil) {
        self.center = center
        self.selectedLayer = 0
        self.orbitalPaths = orbitalPaths
    }
}
