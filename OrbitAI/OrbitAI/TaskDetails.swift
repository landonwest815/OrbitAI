//
//  TaskDetails.swift
//  OrbitAI
//
//  Created by Landon West on 1/31/24.
//

import SwiftUI

struct TaskDetails: View {
    
    var title: String
    var description: String
    var deadline: Date
    
    init(title: String, description: String, deadline: Date) {
        self.title = title
        self.description = description
        self.deadline = deadline
    }
    
    var body: some View {
        VStack {
            Text("**\(title)**")
                .font(.system(size: 30))
                .fontDesign(.monospaced)
                .fontWeight(.ultraLight)
                .frame(width: 500)
                .padding(.bottom, 10)
                .shadow(color: .white, radius: 10, x: 0, y: 0)
            Text("\(description) \n \n This is due by **\(deadline.formatted())**.")
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

#Preview {
    TaskDetails(title: "Stats Homework", description: "Complete 9 problems on some topics\n\n• Bernoulli Trials\n• Random Variables", deadline: Date().advanced(by: TimeInterval(604800)))
}
