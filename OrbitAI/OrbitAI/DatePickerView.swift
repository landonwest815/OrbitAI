//
//  DatePickerView.swift
//  OrbitAI
//
//  Created by Landon West on 2/5/24.
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedDate = Date()
    
    
    var body: some View {
        
        let datePicker = DatePicker(
            "Select a date",
            selection: $selectedDate,
            displayedComponents: [.date, .hourAndMinute]
        )
        .datePickerStyle(.compact)
        .frame(maxWidth: 300)
        
        Form {
            
            Section {
                
                datePicker
                    .onAppear() {
                        datePicker.setValue(Color.white, forKey: "backgroundColor")

                    }
                

                
            }
            
        }
    }
}

#Preview {
    DatePickerView()
}
