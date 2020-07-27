//
//  NewAddBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewAddHourBlockView: View {
    
    @Binding var isPresented: Bool
    let hour: Int
    let day: Date
    let onAdded: (NewHourBlock) -> Void
    
    @StateObject var viewModel = AddHourBlockViewModel()
    @State var title = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NewNeonTextField(input: $title,
                                     didReturn: addHourBlock)
                    NewIconButton(iconName: "plus",
                                  iconWeight: .bold,
                                  action: addHourBlock)
                }.padding(24)
                
                Text("Suggestions")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding(.leading, 32)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        if !viewModel.currentSuggestions.isEmpty {
                            ForEach(viewModel.currentSuggestions) { suggestion in
                                SuggestionBlockView(suggestion: suggestion,
                                                    onAdded: { addSuggestionBlock(for: suggestion) })
                            }
                        } else {
                            NoSuggestionsBlockView()
                        }
                    }.padding(.top, 8)
                }
            }.navigationTitle("Add an Hour Block")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }
        .onAppear {
            viewModel.loadSuggestions(for: hour, on: day)
        }
        .accentColor(Color("AccentColor"))
    }
    
    func addSuggestionBlock(for suggestion: Suggestion) {
        title = suggestion.title
        addHourBlock()
    }
    
    func addHourBlock() {
        let hourBlock = NewHourBlock(day: day, hour: hour, title: title)
        
        viewModel.add(hourBlock)
        onAdded(hourBlock)
        
        dismiss()
    }
    
    func dismiss() {
        isPresented = false
    }
}

struct AddHourBlockView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddHourBlockView(isPresented: .constant(true),
                         hour: 5,
                         day: Date(),
                         onAdded: { hourBlock in })
    }
}
