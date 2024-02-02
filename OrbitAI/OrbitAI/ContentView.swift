//
//  ContentView.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context    // Data
    @Query var orbitTasks: [OrbitTask]      // Current Tasks
    @State private var field: String = ""   // Prompt TextField
    @State private var showDetails: Bool = false    // Shows Task Details when planet is clicked
    @State private var selectedLayer: CGFloat = -1.0    // Non-Selection: -1, Sun: 0, Tasks: 1+
    @FocusState private var textFieldFocused: Bool  // Focuses TextField when Sun is clicked
    @State private var aiOn: Bool = false   // Controls help of AI
    
    var body: some View {
            
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: Starry Sky
                    StarryBackgroundView()
                
                // MARK: Sun + Planets + Task Details
                VStack {
                    HStack {
                        
                        // MARK: Sun + Planets
                        ZStack {
                                
                            // MARK: Planets + Orbit Paths
                            ForEach(orbitTasks, id: \.id) { task in
                                
                                ZStack {
                                    // MARK: Orbit Paths
                                    if !task.isSun {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 1))
                                            .frame(width: 75 + (task.layer * 75), height: 75 + (task.layer * 75))
                                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 0.7 : 0.2 )
                                            .animation(.easeInOut(duration: 0.25), value: selectedLayer)
                                    }
                                    
                                    // MARK: Planets
                                    Planet(size: CGFloat(task.size ?? 20), layer: task.layer, color: task.colorHex, selection: $selectedLayer)
                                        .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 1.0 : 0.2)
                                        .animation(.easeInOut(duration: 0.25), value: selectedLayer)
                                }
                            }
                            
                            // MARK: Sun
                            Planet(image: "sun.min.fill", size: 75, layer: 0, color: "FFFFFF",  selection: $selectedLayer)
                                .opacity(selectedLayer < 1 ? 1.0 : 0.2 )
                                .animation(.easeInOut(duration: 0.25), value: selectedLayer)
                                .symbolEffect(.scale.byLayer.up, isActive: selectedLayer == 0)
                        }
                        
                        // MARK: Expanded Task Details
                        if selectedLayer > 0 {
                            VStack {
                                
                                // Grab the Task Data
                                if let selected = orbitTasks.first(where: { $0.layer == selectedLayer }) {
                                    
                                    // Display the Title
                                    Text("**\(selected.title)**")
                                        .font(.system(size: 30))
                                        .fontDesign(.monospaced)
                                        .fontWeight(.ultraLight)
                                        .frame(width: 500)
                                        .padding(.bottom, 10)
                                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                                    
                                    // Display the Information
                                    Text("\(selected.taskDescription)\n\n\(selected.deadline)")
                                        .font(.system(size: 15))
                                        .fontDesign(.monospaced)
                                        .fontWeight(.ultraLight)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 500)
                                        .padding(.leading, 20)
                                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                                    
                                } else {
                                    Text("Error pulling the Task Data")
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                }
                .padding(.top, 150)
                .padding(.bottom, 150)
                    
                
                // MARK: Settings + Prompt
                VStack {
                    
                    // MARK: Settings
                    HStack {
                        Spacer()
                        
                        // MARK: Add Planet Manually
                            HStack {
                                Button { context.insert(OrbitTask(layer: CGFloat(orbitTasks.count) + 1.0, title: "Task #\(orbitTasks.count + 1)", taskDescription: "Description #\(orbitTasks.count + 1)", deadline: Date()))
                                }
                                label: {
                                    Image(systemName: "plus")
                                }
                                .padding(20)
                            }
                        
                        // MARK: Toggle AI Features
                        Image(systemName: "sparkles")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(.orange)
                        Toggle("", isOn: $aiOn)
                            .toggleStyle(SwitchToggleStyle(tint: .white))
                            .padding(.trailing, 20)
                            .disabled(selectedLayer > -1)
                    }
                    .padding(30)
                    .opacity(selectedLayer < 0 ? 1.0 : 0.2 )
                    
                    Spacer()
                    
                    // MARK: Prompt
                    HStack {
                        if selectedLayer == 0 {
                            ZStack {
                                
                                // Prompt Border
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10) // Set the corner radius
                                        .stroke(lineWidth: 1) // Set the line width for the stroke
                                        .frame(width: 750, height: 50)
                                        .foregroundStyle(.orange)
                                        .padding(25)
                                        .opacity(0.7)
                                        .padding(.leading, 200)
                                        .padding(.trailing, 200)
                                }
                                
                                // Prompt TextField
                                TextField("What do you need to get done?", text: $field)
                                    .frame(width: 750, height: 150)
                                    .textFieldStyle(.plain)
                                    .fontDesign(.monospaced)
                                    .foregroundStyle(.orange)
                                    .padding(.leading, 50)
                                    .focused($textFieldFocused)
                                    .onAppear() {
                                        textFieldFocused = true
                                    }
                                    .submitLabel(.done)
                                    .onSubmit {
                                        field = ""
                                    }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedLayer = -1
                    textFieldFocused = false
                }
            }
            .onAppear() {
                do {
                    try context.delete(model: OrbitTask.self)
                } catch {
                    print("Failed to clear all Task Data.")
                }
            }
        }
    }
    
    // MARK: Stars
    struct StarView: View {
        var body: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 2, height: 2) // Small star size
                .shadow(radius: 3) // Glowing effect
        }
    }

    // MARK: Stars Background
    struct StarryBackgroundView: View {
        let numberOfStars: Int = 100 // Adjust the number of stars to your liking

        var body: some View {
            GeometryReader { geometry in
                ForEach(0..<numberOfStars, id: \.self) { _ in
                    StarView()
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.3...1)) // Random opacity for a twinkling effect
                }
            }
            .background(.black)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: OrbitTask.self, configurations: config)
    let orbitTask = OrbitTask(layer: 1, title: "Test", taskDescription: "Testing", deadline: Date.now)
    container.mainContext.insert(orbitTask)

    return ContentView()
           .modelContainer(container)
}
