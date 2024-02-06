//
//  OrbitalPathView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI
import SwiftData

struct OrbitalPathView: View {
    
    var orbitalPath: OrbitalPath
    
    var body: some View {

        ZStack {
                
                ZStack {
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .frame(width: 100 + CGFloat((orbitalPath.layer * 100)), height: 100 + CGFloat((orbitalPath.layer * 100)))
                    
                    OrbitalSystemView(orbitalSystem: orbitalPath.planetaryBody)
                        .offset(x:orbitalPath.radius * cos(orbitalPath.angle), y: orbitalPath.radius * sin(orbitalPath.angle))
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                                orbitalPath.angle += (orbitalPath.direction == 1) ? (0.002 / CGFloat(orbitalPath.layer)) : (-0.002 / CGFloat(orbitalPath.layer))
                                if orbitalPath.angle > 2 * .pi {
                                    orbitalPath.angle = 0
                                }
                            }
                        }
                    
                }
            
        }
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PlanetaryBody.self, OrbitalPath.self, configurations: config)
    
    let planetaryBody = PlanetaryBody()
    container.mainContext.insert(planetaryBody)
    
    let orbitalPath = OrbitalPath(planetaryBody: planetaryBody, layer: 1)
    container.mainContext.insert(orbitalPath)
    
    planetaryBody.addOrbital(orbital: orbitalPath)
    
    return OrbitalPathView(orbitalPath: orbitalPath)
        .modelContainer(container)

}
