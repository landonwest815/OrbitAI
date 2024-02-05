//
//  OrbitAIApp.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI
import SwiftData

@main
struct OrbitAIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            OrbitTask.self,
            PlanetaryBody.self,
            OrbitalPath.self,
            OrbitalSystem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
