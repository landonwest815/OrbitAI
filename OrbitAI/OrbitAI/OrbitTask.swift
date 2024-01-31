//
//  OrbitTask.swift
//  OrbitAI
//
//  Created by Landon West on 1/31/24.
//

import Foundation
import SwiftData
import SwiftUI

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
    
    init(layer: CGFloat, colorHex: String, title: String, taskDescription: String, deadline: Date) {
        self.size = CGFloat.random(in: 20...40)
        self.layer = layer
        self.colorHex = colorHex
        self.isSun = (layer == 0) ? true : false
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        
        self.title = title
        self.taskDescription = taskDescription
        self.deadline = deadline
    }
    
    init(image: String, layer: CGFloat, colorHex: String, title: String, taskDescription: String, deadline: Date) {
        self.image = image
        self.size = CGFloat.random(in: 20...40)
        self.layer = layer
        self.colorHex = colorHex
        self.isSun = (layer == 0) ? true : false
        self.ringRadius = CGFloat(37.5 + (Double(layer) / (2.0)) * 75.0)
        self.direction = Bool.random() ? 1 : -1
        
        self.title = title
        self.taskDescription = taskDescription
        self.deadline = deadline
    }
}
