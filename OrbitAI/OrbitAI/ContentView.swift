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
                
                VStack {
                    HStack {
                        ZStack {
                            
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .frame(width: 150, height: 150)
                                .opacity(showDetails || showTextField ? 0.3 : 0.7)
                            
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .frame(width: 225, height: 225)
                                .opacity(0.7)
                                .opacity(showTextField ? 0.3 : 1)
                            
                            Circle()
                                .stroke(style: StrokeStyle(lineWidth: 1))
                                .frame(width: 300, height: 300)
                                .opacity(showDetails || showTextField ? 0.3 : 0.7)

                            ZStack {
                                
                                Planet(image: "sun.min.fill", size: 75, x: 0, y: 0, color: .orange)
                                    .onTapGesture {
                                        showTextField = true
                                        showDetails = false
                                    }
                                    .symbolEffect(.scale.byLayer.up, isActive: showTextField)
                                    .opacity(showDetails ? 0.3 : 1)

                                
                                ZStack {
                                    Planet(size: 15, x: -100, y: -110, color: .red)
                                        .opacity(showDetails || showTextField ? 0.3 : 1)
                                    
                                    
                                    Planet(size: 25, x: 200, y: 100, color: .blue)
                                        .onTapGesture {
                                            showDetails.toggle()
                                            if showDetails {        showTextField = false
                                            }
                                        }
                                        .opacity(showTextField ? 0.3 : 1)
                                    
                                    Planet(size: 30, x: -80, y: 290, color: .purple)
                                        .opacity(showDetails || showTextField ? 0.3 : 1)

                                }
                                .rotationEffect(angle)
                            }
                            .symbolEffect(.bounce, value: showTextField)
                            .symbolEffect(.bounce, value: showDetails)
                        }
                        if showDetails {
                            Text("Statistics Homework")
                                .font(.system(size: 30))
                                .fontDesign(.monospaced)
                                .fontWeight(.ultraLight)
                                .padding(20)
                                .frame(width: 500)
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
