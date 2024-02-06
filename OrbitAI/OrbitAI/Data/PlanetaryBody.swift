//
//  PlanetaryBody.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import Foundation
import SwiftData
import SwiftUI

let bodyColors: [String] = ["FF0000", "0000FF", "800080"]

@Model
class PlanetaryBody {
    var color: String
    var size: CGFloat
    var image: String? = ""
    var orbitals: [OrbitalPath]?
    
    init(color: String? = bodyColors.randomElement(), size: CGFloat? = CGFloat.random(in: 30...50), image: String? = nil, orbitals: [OrbitalPath]? = nil) {
        self.color = color ?? "FFFFFF"
        self.size = size ?? 25
        self.image = image
        self.orbitals = orbitals ?? []
    }
    
    func addOrbital(orbital: OrbitalPath) {
        self.orbitals?.append(orbital)
    }
}
