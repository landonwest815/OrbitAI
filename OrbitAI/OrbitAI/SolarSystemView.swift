//
//  SolarSystemView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI
import SwiftData

struct SolarSystemView: View {
    @Environment(\.modelContext) var context    // Data
    @Query var orbitTasks: [OrbitTask]
    @Query var solarSystems: [SolarSystem]
    
    var body: some View {
        
        ZStack {
            
            // MARK: Planets + Orbit Paths
            ForEach(solarSystems, id: \.id) { task in
                
                ZStack {
                    // MARK: Orbit Paths
                    if !task.isSun {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .frame(width: 100 + (task.layer * 100), height: 100 + (task.layer * 100))
                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 0.7 : 0.2 )
                            .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                    }
                    
                    // MARK: Planets
                        Planet(size: CGFloat(task.size ?? 20), layer: task.layer, color: task.colorHex, selection: $selectedLayer)
                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 1.0 : 0.2)
                            .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                    
                }
            }
            
            // MARK: Sun
            Planet(image: "sun.min.fill", size: 100, layer: 0, color: "FFFFFF",  selection: $selectedLayer)
                .opacity(selectedLayer < 1 ? 1.0 : 0.2 )
                .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                .symbolEffect(.scale.byLayer.up, isActive: selectedLayer == 0)
        }
        
    }
}

#Preview {
    SolarSystemView()
}
