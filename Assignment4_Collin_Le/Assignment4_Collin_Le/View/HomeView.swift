//
//  SwiftUIView.swift
//  Assignment4_Collin_Le
//
//  Created by Collin Le on 11/22/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showingNewEntrySheet = false
    @State private var journalViewModel = JournalViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("")
                
                    .navigationTitle("MoodNotes")
                    .navigationBarTitleDisplayMode(.inline)
                
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                showingNewEntrySheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Analyze All") {
                                journalViewModel.analyzeAll()
                            }
                        }
                    }
                
                    List {
                        ForEach(journalViewModel.entries) { entry in
                            NavigationLink {
                                EntryDetailsView(
                                            journalViewModel: journalViewModel,
                                            entry: entry
                                        )
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(entry.title)
                                                
                                                Spacer()
                                                
                                                Text(entry.analysisStatus)
                                            }
                                            Text("\(entry.date.formatted(date: .long, time: .shortened))")
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                    }
                                    .buttonStyle(.plain)
                            }
                        .onDelete { indexSet in
                            journalViewModel.entries.remove(atOffsets: indexSet)}
                        }
                    
                }
            }
            
            .sheet(isPresented: $showingNewEntrySheet) {
                AddEntryView(journalViewModel: journalViewModel)
            }
        }
    }

#Preview {
    HomeView()
}
