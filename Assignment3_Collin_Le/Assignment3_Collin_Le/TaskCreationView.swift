//
//  TaskCreationView.swift
//  Assignment3_Collin_Le
//
//  Created by Collin Le on 11/3/26.
//

import SwiftUI
import MapKit

struct TaskCreationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var taskDescription = ""
    @State private var dueDate = Date()
    
    let coordinate: CLLocationCoordinate2D
        var onSave: (LocationTask) -> Void
        
        private var isValid: Bool {
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !taskDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            dueDate >= Calendar.current.startOfDay(for: Date())
        }
        
        var body: some View {
            NavigationView {
                Form {
                    Section("Task Information") {
                        TextField("Task Name", text: $name)
                        
                        TextField("Description", text: $taskDescription, axis: .vertical)
                            .lineLimit(3...5)
                    }
                    
                    Section("Due Date") {
                        DatePicker(
                            "Select Date",
                            selection: $dueDate,
                            in: Calendar.current.startOfDay(for: Date())...,
                            displayedComponents: .date
                        )
                    }
                    
                    Section("Location") {
                        Text("Latitude: \(coordinate.latitude)")
                        Text("Longitude: \(coordinate.longitude)")
                    }
                    
                    Section {
                        Button("Create Task") {
                            let newTask = LocationTask(
                                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                taskDescription: taskDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                                dueDate: dueDate,
                                latitude: coordinate.latitude,
                                longitude: coordinate.longitude
                            )
                            
                            onSave(newTask)
                            dismiss()
                        }
                        .disabled(!isValid)
                        .frame(maxWidth: .infinity)
                    }
                }
                .navigationTitle("New Task")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
}
