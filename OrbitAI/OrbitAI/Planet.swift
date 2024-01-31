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
    var x: CGFloat
    var y: CGFloat
    var color: Color
    
    init(size: CGFloat, x: CGFloat, y: CGFloat, color: Color) {
        self.size = size
        self.x = x
        self.y = y
        self.color = color
    }
    
    init(image: String, size: CGFloat, x: CGFloat, y: CGFloat, color: Color) {
        self.image = image
        self.size = size
        self.x = x
        self.y = y
        self.color = color
    }
    
    var body: some View {
        Image(systemName: (image != "") ? image : "circle.fill")
            .resizable()
            .frame(width: size, height: size)
            .padding(.leading, (x > 0) ? x : 0)
            .padding(.trailing, (x < 0) ? abs(x) : 0)
            .padding(.top, (y < 0) ? abs(y) : 0)
            .padding(.bottom, (y > 0) ? y : 0)
            .foregroundStyle(color)
            .shadow(color: color, radius: 5, x: 0, y: 0)
    }
}

#Preview {
    Planet(size: 15, x: -110, y: -105, color: .red)
}
