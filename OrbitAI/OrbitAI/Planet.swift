//
//  Planet.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI

struct Planet: View {
   
    var image: String = ""
    var size: CGFloat?
    var layer: CGFloat
    var color: Color
    var isSun: Bool = false
    var ringRadius: CGFloat
    var direction: CGFloat
    var active: Bool = false
    
    @Binding var selection: CGFloat
    
    @State private var angle = 0.0
    
    init(size: CGFloat, layer: CGFloat, color: String, selection: Binding<CGFloat>) {
        self.size = size
        self.layer = layer
        self.color = Color(hex: color) ?? .red
        if layer == 0 { isSun = true }
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        self._selection = selection
    }
    
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
            if isSun {
                Image(systemName: image)
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
                    .shadow(color: color, radius: 5, x: 0, y: 0)
                    .symbolEffect(.scale.byLayer.up, isActive: active)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = self.layer
                        }
                    }
            }
            else
            {
                Image(systemName: "circle.fill")
                    .resizable()
                    .offset(x: ringRadius * cos(CGFloat(angle)), y: ringRadius * sin(CGFloat(angle)))
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
                    .shadow(color: color, radius: 5, x: 0, y: 0)
                    .onAppear {
                        // Timer to update the angle
                        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                            self.angle += (self.direction == 1) ? (0.002 / layer) : (-0.002 / layer)
                            if self.angle > 2 * .pi {
                                self.angle = 0
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = self.layer
                        }
                    }
                    .symbolEffect(.bounce, value: selection == self.layer)

                
            }
        }

    }
}

#Preview {
    @State var toggle: CGFloat = -1.0
    return Planet(size: 15, layer: 2, color: "FFFFFF", selection: $toggle)
}
