//
//  TaskDetails.swift
//  OrbitAI
//
//  Created by Landon West on 1/31/24.
//

import SwiftUI

struct TaskDetails: View {
    
    var title: String           // Title to display
    var description: String     // Description to display
    var deadline: Date          // Deadline to display
    
    init(title: String, description: String, deadline: Date) {
        self.title = title
        self.description = description
        self.deadline = deadline
    }
    
    var body: some View {
        VStack {
            // MARK: Title
            Text("**\(title)**")
                .font(.system(size: 30))
                .padding(.bottom, 10)
            
            // MARK: Description + Deadline
            Text("\(description) \n \n This is due by **\(deadline.formatted())**.")
                .font(.system(size: 15))
                .padding(.leading, 20)
        }
        .fontDesign(.monospaced)
        .fontWeight(.ultraLight)
        .multilineTextAlignment(.leading)
        .frame(width: 500)
        .shadow(color: .white, radius: 10, x: 0, y: 0)
    }
}

#Preview {
    TaskDetails(title: "Stats Homework", description: "Complete 9 problems on some topics\n\n• Bernoulli Trials\n• Random Variables", deadline: Date().advanced(by: TimeInterval(604800)))
}
