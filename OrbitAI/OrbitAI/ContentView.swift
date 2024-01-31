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
    
    @State private var angle: Angle = .zero
    @GestureState private var dragState = DragState.inactive
    private let circleRadius: CGFloat = 50
    
    @State private var field: String = ""
    
    @State private var showDetails: Bool = false
    @State private var showTextField: Bool = false
    
    var body: some View {
            
            
            ZStack {
                
                StarryBackgroundView()
                    .background(Color.black)
                
                HStack {
                    Button { context.insert(OrbitTask(layer: CGFloat(orbitTasks.count) + 1.0, colorHex: "FFFFFF", title: "Test", taskDescription: "Testing", deadline: Date()))
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
                                            .opacity(0.7)
                                        
                                    }
                                    
                                    Planet(size: CGFloat(task.size ?? 20), layer: task.layer, color: task.colorHex)
                                }
                            }
                            
//                            Circle()
//                                .stroke(style: StrokeStyle(lineWidth: 1))
//                                .frame(width: 225, height: 225)
//                                .opacity(0.7)
//                                .opacity(showTextField ? 0.3 : 1)
//                            
//                            Circle()
//                                .stroke(style: StrokeStyle(lineWidth: 1))
//                                .frame(width: 300, height: 300)
//                                .opacity(showDetails || showTextField ? 0.3 : 0.7)

                            ZStack {
                                
                                Planet(image: "sun.min.fill", size: 75, layer: 0, color: "FFFFFF")
                                    .onTapGesture {
                                        showTextField = true
                                        showDetails = false
                                    }
//                                    .symbolEffect(.scale.byLayer.up, isActive: showTextField)
//                                    .opacity(showDetails ? 0.3 : 1)
//
//                                
//                                ZStack {
//                                    Planet(size: 15, layer: 1, color: "FFFFFF")
//                                        .opacity(showDetails || showTextField ? 0.3 : 1)
//                                    
//                                    
//                                    Planet(size: 25, layer: 2, color: "FFFFFF")
//                                        .onTapGesture {
//                                            showDetails.toggle()
//                                            if showDetails {        showTextField = false
//                                            }
//                                        }
//                                        .opacity(showTextField ? 0.3 : 1)
//                                    
//                                    Planet(size: 30, layer: 3, color: "FFFFFF")
//                                        .opacity(showDetails || showTextField ? 0.3 : 1)
//
//                                }
                            }
//                            .symbolEffect(.bounce, value: showTextField)
//                            .symbolEffect(.bounce, value: showDetails)
                        }
                        if showDetails {
                            VStack {
                                Text("**Stats Homework**")
                                    .font(.system(size: 30))
                                    .fontDesign(.monospaced)
                                    .fontWeight(.ultraLight)
                                    .frame(width: 500)
                                    .padding(.bottom, 10)
                                    .shadow(color: .white, radius: 10, x: 0, y: 0)
                                Text("Complete 9 problems on the following topics: \n \n   • **Bernoulli Trials** \n   • **Random Variables** \n   • **Independence** \n \n This is due by next **Tuesday**.")
                                    .font(.system(size: 15))
                                    .fontDesign(.monospaced)
                                    .fontWeight(.ultraLight)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 500)
                                    .padding(.leading, 20)
                                    .shadow(color: .white, radius: 10, x: 0, y: 0)

                            }
                        }
                    }
                    .animation(.easeInOut)
                }
                .padding(.top, 150)
                .padding(.bottom, 150)
                                    
                VStack {
                    
                    Spacer()
                    HStack {
                        if showTextField {
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
                                    .foregroundStyle(.orange)
                                    .padding(.leading, 50)
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                showTextField = false
            }
            .onAppear() {
                do {
                    try context.delete(model: OrbitTask.self)
                } catch {
                    print("Failed to clear all Country and City data.")
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
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
