//
//  ContentView.swift
//  OrbitAI
//
//  Created by Landon West on 1/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) var context    // Data
    @Query var orbitTasks: [OrbitTask]      // Current Tasks
    @State private var field: String = ""   // Prompt TextField
    @State private var showDetails: Bool = false    // Shows Task Details when planet is clicked
    @State private var selectedLayer: CGFloat = -1.0    // Non-Selection: -1, Sun: 0, Tasks: 1+
    @State var selectedTask: OrbitTask?
    @FocusState private var textFieldFocused: Bool  // Focuses TextField when Sun is clicked
    @State private var aiOn: Bool = false   // Controls help of AI
    
    @State private var promptInstructions = ["1. task name", "2. task details + description", "3. task deadline"]
    @State private var promptPlaceholders = ["What do you want to name your task?", "Give a summary of what the task consists of.", "When must this task be completed?"]
    @State private var promptStep: Int = 0
    @State private var newTaskTitle: String = ""
    @State private var newTaskDescription: String = ""
    @State private var newTaskDeadline: String = ""
    
    @State private var detailsTitle: String = ""
    @State private var detailsDescription: String = ""
    
    @State private var date = Date.now

    
    var body: some View {
            
        GeometryReader { geometry in
            
            ZStack {
                
                // MARK: Starry Sky
                StarryBackgroundView()
                
                // MARK: Sun + Planets + Task Details
                VStack {
                    HStack {
                        
                        // MARK: Sun + Planets
                        ZStack {
                            
                            // MARK: Planets + Orbit Paths
                            ForEach(orbitTasks, id: \.id) { task in
                                
                                ZStack {
                                    // MARK: Orbit Paths
                                    if !task.isSun {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 1))
                                            .frame(width: 100 + (task.layer * 100), height: 100 + (task.layer * 100))
                                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 0.7 : 0.2 )
                                            .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                                    }
                                    
                                    // MARK: Planets
                                        Planet(size: CGFloat(task.size ?? 20), layer: task.layer, color: task.colorHex, selection: $selectedLayer)
                                            .opacity(((selectedLayer < 0 || selectedLayer == task.layer) && selectedLayer != 0) ? 1.0 : 0.2)
                                            .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                                    
                                }
                            }
                            
                            // MARK: Sun
                            Planet(image: "sun.min.fill", size: 100, layer: 0, color: "FFFFFF",  selection: $selectedLayer)
                                .opacity(selectedLayer < 1 ? 1.0 : 0.2 )
                                .animation(.easeInOut(duration: 0.33), value: selectedLayer)
                                .symbolEffect(.scale.byLayer.up, isActive: selectedLayer == 0)
                        }
                        
                        // MARK: Expanded Task Details
                        if selectedLayer > 0 {
                            ZStack {
                                
                                // Grab the Task Data
                                if selectedTask != nil {
                                    
                                    VStack {
                                        // Display the Title
                                        TextField("", text: $detailsTitle)
                                            .focused($textFieldFocused)
                                            .font(.system(size: 30))
                                            .fontWeight(.bold)
                                            .textFieldStyle(.plain)
                                            .submitLabel(.done)
                                            .fontDesign(.monospaced)
                                            .fontWeight(.ultraLight)
                                            .frame(width: 500)
                                            .padding(.leading, 75)
                                            .padding(.bottom, 25)
                                            .shadow(color: .white, radius: 10, x: 0, y: 0)
                                            .onChange(of: detailsTitle) { newValue in
                                                if textFieldFocused {
                                                    selectedTask?.title = newValue
                                                }
                                            }
                                            .onSubmit {
                                                textFieldFocused = false
                                            }
                                        
                                        // Display the Information
                                        TextEditor(text: $detailsDescription)
                                            .focused($textFieldFocused)
                                            .font(.system(size: 15))
                                            .scrollContentBackground(.hidden)
                                            .scrollClipDisabled(true)
                                            .scrollIndicators(.never)
                                            .submitLabel(.done)
                                            .fontDesign(.monospaced)
                                            .fontWeight(.ultraLight)
                                            .multilineTextAlignment(.leading)
                                            .frame(maxHeight: 100)
                                            .clipShape(Rectangle())
                                            .shadow(color: .white, radius: 10, x: 0, y: 0)
                                            .onChange(of: detailsDescription) { newValue in
                                                if textFieldFocused {
                                                    selectedTask?.taskDescription = newValue
                                                }
                                            }
                                            .onSubmit {
                                                textFieldFocused = false
                                            }
                                        
                                        Button {
                                            if let taskToDelete = selectedTask {
                                                context.delete(taskToDelete)
                                            }
                                            selectedLayer = -1
                                        }
                                        label: {
                                            Text("Delete")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    .onAppear {
                                        detailsTitle = selectedTask?.title ?? ""
                                        detailsDescription = selectedTask?.taskDescription ?? ""
                                    }
                                } else {
                                    Text("Error pulling the Task Data")
                                }
                            }
                            .frame(width: 500)
                            .padding(.leading, 50)
                            .transition(.opacity)
                        }
                    }
                }
                .padding(.top, 150)
                .padding(.bottom, 150)
                
                
                // MARK: Settings + Prompt
                VStack {
                    
                    // MARK: Settings
                    HStack {
                        Spacer()
                        
                        // MARK: Add Planet Manually
                        HStack {
                            Button { context.insert(OrbitTask(layer: CGFloat(orbitTasks.count) + 1.0, title: "Task #\(orbitTasks.count + 1)", taskDescription: "Description #\(orbitTasks.count + 1)", deadline: Date()))
                            }
                        label: {
                            Image(systemName: "plus")
                        }
                        .padding(20)
                        }
                        
                        // MARK: Toggle AI Features
                        Image(systemName: "sparkles")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(.orange)
                        Toggle("", isOn: $aiOn)
                            .toggleStyle(SwitchToggleStyle(tint: .white))
                            .padding(.trailing, 20)
                            .disabled(selectedLayer > -1)
                    }
                    .padding(30)
                    .opacity(selectedLayer < 0 ? 1.0 : 0.2 )
                    
                    Spacer()
                    
                    // MARK: Prompt
                    HStack {
                        if selectedLayer == 0 {
                            ZStack {
                                
                                VStack {
                                    
                                
                                    Text(promptInstructions[promptStep]).fontDesign(.monospaced)
                                        .foregroundStyle(.orange)
                                        .font(.system(size: 25))
                                        
                                    
                                    // Prompt Border
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10) // Set the corner radius
                                            .stroke(lineWidth: 1) // Set the line width for the stroke
                                            .frame(width: 750, height: 50)
                                            .foregroundStyle(.orange)
                                            .padding(25)
                                            .opacity(0.7)
                                            .padding(.leading, 200)
                                            .padding(.trailing, 200)
                                        
                                        // Prompt TextField
                                        TextField(promptPlaceholders[promptStep], text: $field)
                                            .frame(width: 700, height: 150)
                                            .textFieldStyle(.plain)
                                            .fontDesign(.monospaced)
                                            .foregroundStyle(.orange)
                                            .focused($textFieldFocused)
                                            .onAppear() {
                                                textFieldFocused = true
                                            }
                                            .submitLabel(.done)
                                            .onSubmit {
                                                if promptStep == 0 {
                                                    newTaskTitle = field
                                                }
                                                else if promptStep == 1 {
                                                    newTaskDescription = field
                                                }
                                                else if promptStep == 2 {
                                                    newTaskDeadline = field
                                                }
                                                
                                                field = ""
                                                
                                                if promptStep == 2 {
                                                    completeTaskSetup()
                                                } else {
                                                    promptStep += 1
                                                }
                                            }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.33)) {
                    selectedLayer = -1
                    promptStep = 0
                    textFieldFocused = false
                }
            }
            .onChange(of: selectedLayer) {
                if selectedLayer > 0 {
                    selectedTask = orbitTasks.first(where: { $0.layer == selectedLayer })
                    detailsTitle = selectedTask?.title ?? ""
                    detailsDescription = selectedTask?.taskDescription ?? ""
                    textFieldFocused = false
                }
                else {
                    selectedTask = nil
                }
            }
        }
    }
    
    func completeTaskSetup() {
        
        let newTask = OrbitTask(layer: CGFloat(orbitTasks.count) + 1, title: newTaskTitle, taskDescription: newTaskDescription, deadline: Date().advanced(by: 1000000))
        context.insert(newTask)
        
        selectedLayer = -1
        promptStep = 0
    }
    
    // MARK: Stars
    struct StarView: View {
        var body: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 2, height: 2) // Small star size
                .shadow(radius: 3) // Glowing effect
        }
    }

    // MARK: Stars Background
    struct StarryBackgroundView: View {
        let numberOfStars: Int = 100 // Adjust the number of stars to your liking

        var body: some View {
            GeometryReader { geometry in
                ForEach(0..<numberOfStars, id: \.self) { _ in
                    StarView()
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .opacity(Double.random(in: 0.3...1)) // Random opacity for a twinkling effect
                }
            }
            .background(.black)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: OrbitTask.self, configurations: config)
    let orbitTask = OrbitTask(layer: 1, title: "Test", taskDescription: "Testing", deadline: Date.now)
    container.mainContext.insert(orbitTask)

    return ContentView()
           .modelContainer(container)
}
