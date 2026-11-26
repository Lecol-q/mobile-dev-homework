//
//  TaskListView.swift
//  Assignment3_Collin_Le
//
//  Created by Collin Le on 11/3/26.
//



import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var tasks: [LocationTask]
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                VStack(alignment: .leading, spacing: 6) {
                    Text(task.name)
                        .font(.headline)
                    
                    Text(task.taskDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Due: \(task.dueDate.formatted(date: .numeric, time: .omitted))")
                        .font(.caption)
                    
                    Text("Lat: \(task.latitude), Lng: \(task.longitude)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(tasks[index])
                }
            }
        }
        .navigationTitle("My Tasks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

