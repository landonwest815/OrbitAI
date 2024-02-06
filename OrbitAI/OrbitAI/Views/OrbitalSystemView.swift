//
//  OrbitalSystemView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI
import SwiftData

struct OrbitalSystemView: View {
    
    var orbitalSystem: PlanetaryBody
    
    var body: some View {
        
        ZStack {
            ForEach(orbitalSystem.orbitals ?? [], id: \.self) { orbitalPath in
                
                OrbitalPathView(orbitalPath: orbitalPath)
                
            }
            
            PlanetaryBodyView(planetaryBody: orbitalSystem)
            
        }
        .frame(width: 500, height:500)
        
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PlanetaryBody.self, OrbitalPath.self, OrbitalSystem.self, configurations: config)
    
    // planets 1 and 2
    let planetaryBody1 = PlanetaryBody()
    container.mainContext
        .insert(planetaryBody1)
    let planetaryBody2 = PlanetaryBody()
    container.mainContext.insert(planetaryBody2)
    
    // paths 1 and 2
    let orbitalPath1 = OrbitalPath(planetaryBody: planetaryBody1, layer: 1)
    let orbitalPath2 = OrbitalPath(planetaryBody: planetaryBody2, layer: 2)
    container.mainContext.insert(orbitalPath1)
    container.mainContext.insert(orbitalPath2)
    
    // planets 3 and 4
    let planetaryBody3 = PlanetaryBody()
    container.mainContext
        .insert(planetaryBody3)
    let planetaryBody4 = PlanetaryBody()
    container.mainContext.insert(planetaryBody4)
    
    // paths 3 and 4
    let orbitalPath3 = OrbitalPath(planetaryBody: planetaryBody3, layer: 1)
    let orbitalPath4 = OrbitalPath(planetaryBody: planetaryBody4, layer: 1)
    container.mainContext.insert(orbitalPath3)
    container.mainContext.insert(orbitalPath4)
    
    planetaryBody1.addOrbital(orbital: orbitalPath3)
    planetaryBody3.addOrbital(orbital: orbitalPath4)
    
    // orbit 5
    let planetaryBody5 = PlanetaryBody(color: "FFA500")
    planetaryBody5.addOrbital(orbital: orbitalPath1)
    planetaryBody5.addOrbital(orbital: orbitalPath2)
    container.mainContext.insert(planetaryBody5)
    
    return OrbitalSystemView(orbitalSystem: planetaryBody5)
        .modelContainer(container)

}
