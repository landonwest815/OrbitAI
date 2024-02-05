//
//  OrbitalPath.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import Foundation
import SwiftData

@Model
class OrbitalPath {
    var planetaryBody: PlanetaryBody
    var direction: Int
    var layer: Int
    var radius: CGFloat
    var angle: CGFloat
    
    init(planetaryBody: PlanetaryBody, layer: Int, direction: Int? = Bool.random() ? 1 : -1) {
        self.planetaryBody = planetaryBody
        self.layer = layer
        self.direction = direction ?? 1
        self.radius = 50 + ((Double(layer) / 2.0) * 100)
        self.angle = 0.0
    }
}
