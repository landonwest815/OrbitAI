//
//  SolarSystem.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import Foundation
import SwiftData

@Model
class SolarSystem {
    private var barycenter: Planet
    private var orbits: [OrbitTask]
    private var selectedOrbit: OrbitTask?
    
    init(barycenter: Planet, orbits: [OrbitTask], selectedOrbit: OrbitTask? = nil) {
        self.barycenter = barycenter
        self.orbits = orbits
        self.selectedOrbit = selectedOrbit
    }
}
