//
//  AddEntryView.swift
//  Assignment4_Collin_Le
//
//  Created by Collin Le on 11/22/26.
//

import SwiftUI

struct AddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @State private var showingDuplicateAlert = false
    
    let journalViewModel: JournalViewModel
    
    @State private var title: String = ""
    @State private var entry: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("What's on your mind?", text: $title)
                    .focused($isFocused)
                    .font(.body)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.secondary.opacity(0.2))
                
                ZStack(alignment: .topLeading) {
                    if entry.isEmpty {
                        Text("Journal your thoughts here")
                            .foregroundStyle(.secondary.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    TextEditor(text: $entry)
                        .focused($isFocused)
                        .scrollContentBackground(.hidden)
                }
                
            }
            .padding()
            
            Button("Submit") {
                let added = journalViewModel.addEntry(title: title, entry: entry)
                
                if added {
                    dismiss()
                } else {
                    showingDuplicateAlert = true
                }
            }
            .alert("This titel has already been added", isPresented: $showingDuplicateAlert) {
                Button("Cancel", role: .cancel) {}
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .padding()
            .disabled(title.count < 3 || title.count > 30 || entry.count < 20 || entry.count > 500)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isFocused = false;
                    }
                }
            }
            
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    AddEntryView(journalViewModel: JournalViewModel())
}
