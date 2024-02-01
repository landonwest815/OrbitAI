//
//  ContentView.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI
import SwiftData

enum DragState {
    case inactive
    case dragging(translation: CGSize)
}

struct ContentView: View {
    
    @Environment(\.modelContext) var context
    @Query var orbitTasks: [OrbitTask]
        
    @State private var field: String = ""
    
    @State private var showDetails: Bool = false
    
    @State private var selectedLayer: CGFloat = -1.0
    
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
            
        GeometryReader { geometry in
            
            ZStack {
                
                StarryBackgroundView()
                    .background(Color.black)
                
                HStack {
                    Button { context.insert(OrbitTask(layer: CGFloat(orbitTasks.count) + 1.0, title: "Task #\(orbitTasks.count + 1)", taskDescription: "Description #\(orbitTasks.count + 1)", deadline: Date()))
                    }
                label: {
                    Image(systemName: "plus")
                }
                    Spacer()
                }
                
                VStack {
                    HStack {
                        ZStack {
                            
                            ForEach(orbitTasks, id: \.id) { task in
                                
                                
                                    ZStack {
                                        if !task.isSun {
                                            Circle()
                                                .stroke(style: StrokeStyle(lineWidth: 1))
                                                .frame(width: 75 + (task.layer * 75), height: 75 + (task.layer * 75))
                                                .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 0.7 : 0.2 )
                                                .animation(.easeInOut(duration: 0.5), value: selectedLayer)

                                            
                                        }
                                        
                                        Planet(size: CGFloat(task.size ?? 20), layer: task.layer, color: task.colorHex, selection: $selectedLayer)
                                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 1.0 : 0.2)
                                            .animation(.easeInOut(duration: 0.5), value: selectedLayer)

                                    }
                                
                                
                            }
                            
                            
                            ZStack {
                                
                                Planet(image: "sun.min.fill", size: 75, layer: 0, color: "FFFFFF",  selection: $selectedLayer)
                                    .opacity(selectedLayer < 1 ? 1.0 : 0.2 )
                                    .animation(.easeInOut(duration: 0.5), value: selectedLayer)

                                
                                
                                
                            }
                            .symbolEffect(.scale.byLayer.up, isActive: selectedLayer == 0)
                        }
                        if selectedLayer > 0 {
                            VStack {
                                if let selected = orbitTasks.first(where: { $0.layer == selectedLayer }) {
                                    // Use taskWithLayer3 here
                                    // This is your OrbitTask where the layer value is 3
                                    
                                    Text("**\(selected.title)**")
                                        .font(.system(size: 30))
                                        .fontDesign(.monospaced)
                                        .fontWeight(.ultraLight)
                                        .frame(width: 500)
                                        .padding(.bottom, 10)
                                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                                    Text("\(selected.taskDescription) \n \n \(selected.deadline)")
                                        .font(.system(size: 15))
                                        .fontDesign(.monospaced)
                                        .fontWeight(.ultraLight)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 500)
                                        .padding(.leading, 20)
                                        .shadow(color: .white, radius: 10, x: 0, y: 0)
                                } else {
                                    // Handle the case where no task has a layer value of 3
                                    Text("Error")
                                }
                            }
                            .transition(.opacity)
                        }
                    }
                }
                .padding(.top, 150)
                .padding(.bottom, 150)
                    
                HStack {
                        if selectedLayer == 0 {
                            ZStack {
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
                .padding(.top, 500)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.33)) {
                    selectedLayer = -1
                    textFieldFocused = false
                }
            }
            .onAppear() {
                do {
                    try context.delete(model: OrbitTask.self)
                } catch {
                    print("Failed to clear all Country and City data.")
                }
            }
        }
    }
    
    struct StarView: View {
        var body: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 2, height: 2) // Small star size
                .shadow(radius: 3) // Glowing effect
        }
    }

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
