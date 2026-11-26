//
//  JournalViewModel.swift
//  Assignment4_Collin_Le
//
//  Created by Collin Le on 11/22/26.
//

import Foundation
import NaturalLanguage

@MainActor
@Observable
class JournalViewModel {
    var entries: [JournalEntry] = []
    var isAnalyzing = false
    
    init() {
        entries = [
            JournalEntry(
                title: "A Good Day",
                entry: "Today was a really productive day. I finished my assignments and had time to relax.",
                date: Date(),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Feeling Stressed",
                entry: "I have been feeling overwhelmed with schoolwork lately. There is so much to do.",
                date: Date().addingTimeInterval(-86400),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Time With Friends",
                entry: "I went out with my friends today. We laughed, talked, and had a great time.",
                date: Date().addingTimeInterval(-172800),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "A Difficult Day",
                entry: "Today was frustrating. Nothing seemed to go according to plan.",
                date: Date().addingTimeInterval(-259200),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Personal Growth",
                entry: "I have been working hard to improve myself. I am proud of the progress I have made.",
                date: Date().addingTimeInterval(-345600),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "A Quiet Weekend",
                entry: "I spent most of the weekend at home relaxing and catching up on sleep.",
                date: Date().addingTimeInterval(-432000),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Unexpected News",
                entry: "I received some unexpected news today. I am not sure how I feel about it yet.",
                date: Date().addingTimeInterval(-518400),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Feeling Motivated",
                entry: "I woke up feeling motivated and ready to accomplish my goals.",
                date: Date().addingTimeInterval(-604800),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "A Bad Morning",
                entry: "I woke up late and had a stressful morning. Hopefully tomorrow goes better.",
                date: Date().addingTimeInterval(-691200),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            ),

            JournalEntry(
                title: "Looking Forward",
                entry: "I am excited about the future and all the opportunities ahead of me.",
                date: Date().addingTimeInterval(-777600),
                analysisStatus: "Not Analyzed",
                detectedLanguage: "Not Analyzed",
                sentimentScore: 0.0,
                sentimentLabel: "Not Analyzed",
                similarEntry: "Not Analyzed"
            )
        ]
    }
    
    func addEntry(title: String, entry: String) -> Bool {
        let isDuplicate = entries.contains {
            $0.title.caseInsensitiveCompare(title) == .orderedSame
        }
        
        guard !isDuplicate else {
            return false
        }
        
        let newEntry = JournalEntry(title: title, entry: entry, date: Date(), analysisStatus: "Not Analyzed", detectedLanguage: "Not Analyzed", sentimentScore: 0.0, sentimentLabel: "Not Analyzed", similarEntry: "Not Analyzed")
        entries.append(newEntry)
        
        return true
    }
    
    func analyzeEntry(_ entry: JournalEntry) {
        guard let index = entries.firstIndex(where: {
                    $0.id == entry.id
                }) else {
                    return
                }

        let language = JournalViewModel.detectLanguage(entry.entry)
        let(score, label) = JournalViewModel.analyzeSentiment(entry.entry)
        
        entries[index].detectedLanguage = language
        entries[index].sentimentScore = score
        entries[index].sentimentLabel = label
        
        if language == "Not Analyzed" {
            entries[index].similarEntry = "Not Analyzed"
            entries[index].analysisStatus = "Analyzed"
            return
        }
        
        let detectedLanguage = NLLanguage(rawValue: language)
        
        entries[index].similarEntry = findSimilarEntry(entries[index], language: detectedLanguage)
        
        entries[index].analysisStatus = "Analyzed"
    }
    
    func analyzeAll() {
        guard !isAnalyzing else { return }
        isAnalyzing = true
        
        let entriesToAnalyze = entries
        
        Task {
            defer {
                isAnalyzing = false
            }
            
            let results = await withTaskGroup(of: AnalysisResult.self) { group in
                for entry in entriesToAnalyze {
                    group.addTask {
                        let language = Self.detectLanguage(entry.entry)
                        
                        return .language(LanguageResult(id: entry.id, language: language))
                    }
                    
                    group.addTask {
                        let(score, label) = Self.analyzeSentiment(entry.entry)
                        
                        return .sentiment(SentimentResult(id: entry.id, score: score, label: label))
                    }
                }
                
                var collectedResults: [AnalysisResult] = []
                
                for await result in group {
                    collectedResults.append(result)
                }
                
                return collectedResults
            }
            
            for result in results {
                switch result {
                case .language(let languageResult):
                    guard let index = entries.firstIndex(where: {
                        $0.id == languageResult.id
                    }) else {
                        continue
                    }
                    entries[index].detectedLanguage = languageResult.language
                    
                case .sentiment(let sentimentResult):
                    guard let index = entries.firstIndex(where: {
                        $0.id == sentimentResult.id
                    }) else {
                        continue
                    }
                    
                    entries[index].sentimentScore = sentimentResult.score
                    entries[index].sentimentLabel = sentimentResult.label
                }
            }
            
            for index in entries.indices {
                let language = entries[index].detectedLanguage
                
                if language == "Not Analyzed" {
                    entries[index].similarEntry = "Not Analyzed"
                    entries[index].analysisStatus = "Analyzed"
                    continue
                }
                
                let detectedLanguage = NLLanguage(rawValue: language)
                
                entries[index].similarEntry = findSimilarEntry(entries[index], language: detectedLanguage)
                entries[index].analysisStatus = "Analyzed"
            }
        }
    }
    
    nonisolated private static func detectLanguage(_ text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        let language = recognizer.dominantLanguage
        
        return language?.rawValue ?? "Not Analyzed"
    }

    nonisolated private static func analyzeSentiment(_ text: String) -> (Double?, String) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (tag, _) = tagger.tag(
            at: text.startIndex,
            unit: .paragraph,
            scheme: .sentimentScore
        )
        
        guard let tag = tag,
                  let score = Double(tag.rawValue) else {
                return (nil, "Not Analyzed")
            }

            var label: String

            if score > 0.20 {
                label = "Positive"
            } else if score < -0.20 {
                label = "Negative"
            } else {
                label = "Neutral"
            }

            return (score, label)
    }

    private func findSimilarEntry(_ entry: JournalEntry, language: NLLanguage) -> String {
        guard let embedding = NLEmbedding.sentenceEmbedding(for: language) else {
            return "Not Analyzed"
        }

        var smallestDistance = Double.infinity
        var mostSimilarEntry: JournalEntry?

        for otherEntry in entries {
            // Don't compare an entry against itself
            if otherEntry.id == entry.id {
                continue
            }
            
            if otherEntry.detectedLanguage != language.rawValue {
                continue
            }

            let distance = embedding.distance(
                between: entry.entry,
                and: otherEntry.entry
            )

            if distance < smallestDistance {
                smallestDistance = distance
                mostSimilarEntry = otherEntry
            }
        }

        return mostSimilarEntry?.title ?? "Not Analyzed"
    }
}

private struct LanguageResult: Sendable {
    let id: UUID
    let language: String
}

private struct SentimentResult: Sendable {
    let id: UUID
    let score: Double?
    let label: String
}

private enum AnalysisResult: Sendable {
    case language(LanguageResult)
    case sentiment(SentimentResult)
}
