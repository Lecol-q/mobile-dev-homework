//
//  EntryDetailsView.swift
//  Assignment4_Collin_Le
//
//  Created by Collin Le on 11/23/26.
//

import SwiftUI

struct EntryDetailsView: View {
    let journalViewModel: JournalViewModel
    let entry: JournalEntry
    
    private var currentEntry: JournalEntry {
        journalViewModel.entries.first(where: {
            $0.id == entry.id
        }) ?? entry
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(currentEntry.title)
                    .font(.body)
                Text("Date Created: \(currentEntry.date.formatted(date: .long, time: .shortened))")
                
                if entry.analysisStatus == "Not Analyzed" {
                    Text("This entry has not been analyzed")
                } else {
                    Text("Language: \(currentEntry.detectedLanguage)")
                    Text("Analysis Status: \(currentEntry.analysisStatus)")
                    Text("Sentiment Score: \(String(describing: currentEntry.sentimentScore))")
                    Text("Sentiment Label: \(currentEntry.sentimentLabel)")
                    Text("Similar Entry: \(currentEntry.similarEntry)")
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.secondary.opacity(0.2))
                
                ZStack {
                    Text(entry.entry)
                }
            }
            .padding()
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Analyze"){
                        print("Analyze button")
                        journalViewModel.analyzeEntry(currentEntry)
                    }
                }
            }
            
            .navigationTitle("Entry Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    EntryDetailsView(
        journalViewModel: JournalViewModel(),
        entry: JournalEntry(
                    title: "A Good Day",
                    entry: "Today was a really productive day!",
                    date: Date(),
                    analysisStatus: "Not Analyzed",
                    detectedLanguage: "Not Analyzed",
                    sentimentScore: 0.0,
                    sentimentLabel: "Not Analyzed",
                    similarEntry: "Not Analyzed"
            )
    )
}
