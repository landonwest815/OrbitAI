//
//  PlanetaryBodyView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI
import SwiftData

struct PlanetaryBodyView: View {
    
    var planetaryBody: PlanetaryBody
    
    var body: some View {
            
        Image(systemName: "circle.fill")
            .resizable()
            .frame(width: planetaryBody.size, height: planetaryBody.size)
            .foregroundStyle(Color(hex:planetaryBody.color) ?? .white)
            .shadow(color: Color(hex:planetaryBody.color) ?? .white, radius: 5, x: 0, y: 0)
        
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PlanetaryBody.self, OrbitalPath.self, configurations: config)
    
    let planetaryBody = PlanetaryBody()
    container.mainContext.insert(planetaryBody)
    
    let orbitalPath = OrbitalPath(planetaryBody: planetaryBody, layer: 1)
    container.mainContext.insert(orbitalPath)
    
    return PlanetaryBodyView(planetaryBody: orbitalPath.planetaryBody)
        .modelContainer(container)

}
