//
//  JounalEntry.swift
//  Assignment4_Collin_Le
//
//  Created by Collin Le on 11/22/26.
//

import Foundation

struct JournalEntry: Identifiable {
    let id = UUID()
    let title: String
    let entry: String
    let date: Date
    var analysisStatus: String
    var detectedLanguage: String
    var sentimentScore: Double?
    var sentimentLabel: String
    var similarEntry: String
}
