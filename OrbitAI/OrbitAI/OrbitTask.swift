//
//  OrbitTask.swift
//  OrbitAI
//
//  Created by Landon West on 1/31/24.
//

import Foundation
import SwiftData
import SwiftUI

// Pre-Determined Set of Colors for added Planets
let colors: [String] = ["FF0000", "0000FF", "800080"]

@Model
class OrbitTask {
    
    var image: String = ""  // Optional Image; Colored Circle otherwise
    var size: CGFloat?      // Optional Size; Random between 20-40 otherwise
    var layer: CGFloat      // Grows outward from 0 (Sun Layer)
    var colorHex: String    // Hexadecimal representation of color selected randomly from the colors array
    var isSun: Bool         // Determined upon intialization
    var ringRadius: CGFloat     // Determined based on math with Layer value
    var direction: CGFloat      // Randomly chosen between counter-clockwise and clockwise
    
    var title: String               // Title of the Task
    var taskDescription: String     // Description of the Task
    var deadline: Date              // Deadline fo the Task
    
    // MARK: Randomly Created Task Planet
    init(layer: CGFloat, title: String, taskDescription: String, deadline: Date) {
        self.size = CGFloat.random(in: 20...40)
        self.layer = layer
        self.colorHex = colors.randomElement() ?? "FFFFFF"
        self.isSun = (layer == 0) ? true : false
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        
        self.title = title
        self.taskDescription = taskDescription
        self.deadline = deadline
    }
    
    // MARK: More Specific Task Planet
    init(image: String, layer: CGFloat, title: String, taskDescription: String, deadline: Date) {
        self.image = image
        self.size = CGFloat.random(in: 20...40)
        self.layer = layer
        self.colorHex = "FFA500"
        self.isSun = (layer == 0) ? true : false
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        
        self.title = title
        self.taskDescription = taskDescription
        self.deadline = deadline
    }
}
