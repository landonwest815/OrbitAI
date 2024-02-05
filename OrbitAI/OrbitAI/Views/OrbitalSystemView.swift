//
//  OrbitalSystemView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI
import SwiftData

struct OrbitalSystemView: View {
    
    var orbitalSystem: OrbitalSystem
    
    var body: some View {
        
        ZStack {
            ForEach(orbitalSystem.orbitalPaths ?? [], id: \.self) { orbitalPath in
                
                OrbitalPathView(orbitalPath: orbitalPath)
                
            }
            
            PlanetaryBodyView(planetaryBody: orbitalSystem.center)
            
        }
        
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PlanetaryBody.self, OrbitalPath.self, OrbitalSystem.self, configurations: config)
    
    let planetaryBody = PlanetaryBody()
    container.mainContext.insert(planetaryBody)
    
    let orbitalPath1 = OrbitalPath(planetaryBody: planetaryBody, layer: 1)
    let orbitalPath2 = OrbitalPath(planetaryBody: planetaryBody, layer: 2)
    container.mainContext.insert(orbitalPath1)
    container.mainContext.insert(orbitalPath2)

    let orbitalPaths = [orbitalPath1, orbitalPath2]

    let orbitalSystem = OrbitalSystem(center: planetaryBody, orbitalPaths: orbitalPaths)
    container.mainContext.insert(orbitalSystem)
    
    return OrbitalSystemView(orbitalSystem: orbitalSystem)
        .modelContainer(container)

}
