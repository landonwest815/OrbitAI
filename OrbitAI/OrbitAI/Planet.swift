//
//  Planet.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI

struct Planet: View {
   
    var image: String = ""  // Optional Planet Image; Random Color Circle otherwise
    var size: CGFloat?      // Optional Planet Size; Random Size from 20-40 otherwise
    var layer: CGFloat      // Grows outwards from Sun at 0
    var color: Color        // Tranformed from Hex to Color in initialization
    var isSun: Bool = false     // Set during intialization
    var ringRadius: CGFloat     // Decided based on math with layer
    var direction: CGFloat      // Randomly decided with a boolean value (counter-clockwise OR clockwise)
    @Binding var selection: CGFloat     // Sets the selected planet for Task Detail Expansion
    @State private var angle = 0.0      // Allows planets to continuously orbit Sun
    
    // MARK: Random Planets as colored circles with random sizes and directions
    init(size: CGFloat, layer: CGFloat, color: String, selection: Binding<CGFloat>) {
        self.size = size
        self.layer = layer
        self.color = Color(hex: color) ?? .red
        if layer == 0 { isSun = true }
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        self._selection = selection
    }
    
    // MARK: Specific to the Sun
    init(image: String, size: CGFloat, layer: CGFloat, color: String, selection: Binding<CGFloat>) {
        self.image = image
        self.size = size
        self.layer = layer
        self.color = Color.orange
        if layer == 0 { isSun = true }
        self.ringRadius = CGFloat((Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        self._selection = selection
    }
    
    var body: some View {
        ZStack {
            
            // MARK: Sun View
            if isSun {
                Image(systemName: image)
                    .resizable()
            }
            
            // MARK: Planet View
            else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .offset(x: ringRadius * cos(CGFloat(angle)), y: ringRadius * sin(CGFloat(angle)))
                    .symbolEffect(.bounce, value: selection == self.layer)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                            self.angle += (self.direction == 1) ? (0.002 / layer) : (-0.002 / layer)
                            if self.angle > 2 * .pi {
                                self.angle = 0
                            }
                        }
                    }
            }
        }
        .frame(width: size, height: size)
        .foregroundStyle(color)
        .shadow(color: color, radius: 5, x: 0, y: 0)
        .onTapGesture {
            withAnimation(.easeInOut) {
                selection = self.layer
            }
        }
    }
}

#Preview {
    @State var toggle: CGFloat = -1.0
    return Planet(size: 15, layer: 2, color: "FFFFFF", selection: $toggle)
}
