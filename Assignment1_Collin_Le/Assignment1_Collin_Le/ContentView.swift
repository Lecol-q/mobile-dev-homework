//
//  ContentView.swift
//  Assignment1_Collin_Le
//
//  Created by Collin Le on 9/9/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainMenu()
    }
}

// main view
let backgroundGradient = LinearGradient(
    colors: [Color.red, Color.blue],
    startPoint: .top, endPoint: .bottom)

struct MainMenu: View {
    @State private var showingSheet = false
    @State private var hobbies = ["Fitness", "Programming", "Cooking", "Reading", "Drawing", "Music", "Studying", "Gaming", "Dancing", "Running"]
    @State private var emoji = [ "🏋️‍♀️", "👾", "🍽️", "📚", "🎨", "🎶", "📖", "🎮", "💃", "🏃‍♀️"]
    
    var body: some View {
        NavigationStack {
            List(hobbies.indices, id: \.self) { index in
                Text(hobbies[index] + " " + emoji[index])
            }
            .navigationTitle("Hobby Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showingSheet.toggle()
                    }
                    label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $showingSheet){
                        SheetView(hobbies: $hobbies, emoji: $emoji)
                            .presentationBackground(.orange.opacity(1))
                            .glassEffect(.regular,
                                         in: .rect(cornerRadius: 20))
                    }
                }
            }
        }
    }
}

// Modal sheet
struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isKeyboardFocused: Bool
    
    @State private var showAlert = false
    @State private var emojiChoice = ""
    @State private var hobbyName: String = ""
    @State private var valid = true
    
    let emojis = ["🏋️‍♀️", "🙈", "🎨", "🎶", "📖", "🎮", "💃", "🏃‍♀️", "🐞", "🕷️",
                  "🙌", "🦺", "🌂", "🐷", "🌿", "🍄", "🧿", "🔮", "🧸", "🪥"]
    
    @Binding var hobbies: [String]
    @Binding var emoji: [String]
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    TextField("Enter Hobby", text: $hobbyName)
                        .focused($isKeyboardFocused)
                        .toolbar {
                            // keyboard dismissing
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                
                                Button{
                                    isKeyboardFocused = false
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                }
                .navigationTitle("New Hobby")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                
                // picker implementation wheel
                Form {
                    Text("Select Emoji")
                    Picker("Select Emoji", selection: $emojiChoice){
                        ForEach(emojis, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Button("Submit"){
                    if hobbies.contains(where: { $0.lowercased() == hobbyName.lowercased() }) {
                        showAlert = true
                    } else {
                        hobbies.append(hobbyName)
                        emoji.append(emojiChoice)
                        dismiss()
                    }
                }
                .font(.system(size: 20))
                .foregroundColor(.orange)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Warning"), message: Text("This hobby has already been added"),
                          primaryButton: .default(Text("Ok")),
                          secondaryButton: .cancel())
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .buttonSizing(.flexible)
                .disabled(hobbyName.count < 3 || hobbyName.count > 16)
                .padding()
            }
        }
    }
}



#Preview {
    ContentView()
}
