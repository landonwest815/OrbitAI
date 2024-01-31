//
//  OrbitTask.swift
//  OrbitAI
//
//  Created by Landon West on 1/31/24.
//

import Foundation
import SwiftData
import SwiftUI

let colors: [String] = ["FF0000", "0000FF", "800080"]

@Model
class OrbitTask {
    
    var image: String = ""
    var size: CGFloat?
    var layer: CGFloat
    var colorHex: String
    var isSun: Bool
    var ringRadius: CGFloat
    var direction: CGFloat
    
    var title: String
    var taskDescription: String
    var deadline: Date
    
    var state: Bool = false
    
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
