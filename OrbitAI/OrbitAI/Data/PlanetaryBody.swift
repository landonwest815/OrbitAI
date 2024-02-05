//
//  PlanetaryBody.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import Foundation
import SwiftData
import SwiftUI

let bodyColors: [String] = ["FF0000", "0000FF", "800080"]

@Model
class PlanetaryBody {
    var color: String
    var size: CGFloat
    var image: String? = ""
    
    init(color: String? = bodyColors.randomElement(), size: CGFloat? = CGFloat.random(in: 30...50), image: String? = nil) {
        self.color = color ?? "FFFFFF"
        self.size = size ?? 25
        self.image = image
    }
    
}
