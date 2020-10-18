//
//  NewAddBlockView.swift
//  Hour Blocks
//
//  Created by James Saeed on 01/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

/// A view where an Hour Block can be added, either by a user inputted title or suggestion.
struct AddHourBlockView: View {
    
    @StateObject private var viewModel = AddHourBlockViewModel()
    
    @State private var hourBlockTitle = ""
    
    @Binding private var isPresented: Bool
    
    private let day: Date
    private let hour: Int
    private let onNewBlockAdded: (HourBlock) -> Void
    
    /// Creates an instance of AddHourBlockView.
    ///
    /// - Parameters:
    ///   - isPresented: A binding determining whether or not the view is presented.
    ///   - day: The day on which the Hour Block is to be added on
    ///   - hour: The hour for which the Hour Block is to be added to
    ///   - onBlockAdded: The callback function to be triggered when the user inputs the Hour Block they would like to add.
    init(isPresented: Binding<Bool>, for day: Date, _ hour: Int, onNewBlockAdded: @escaping (HourBlock) -> Void) {
        self._isPresented = isPresented
        self.day = day
        self.hour = hour
        self.onNewBlockAdded = onNewBlockAdded
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NeonTextField(text: $hourBlockTitle,
                                  onReturn: addHourBlock)
                    IconButton(iconName: "plus",
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
                                SuggestionBlockView(for: suggestion,
                                                    onSuggestionAdded: { addSuggestionBlock(for: suggestion) })
                            }
                        } else {
                            NoSuggestionsBlockView()
                        }
                    }.padding(.top, 8)
                }
            }.navigationTitle("Add an Hour Block")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }.accentColor(Color("AccentColor"))
        .onAppear { viewModel.loadSuggestions(for: hour, on: day) }
    }
    
    /// Uses a given suggestion to add as an Hour Block.
    ///
    /// - Parameters:
    ///   - suggestion: The suggestion to add.
    private func addSuggestionBlock(for suggestion: Suggestion) {
        hourBlockTitle = suggestion.domain.suggestionTitle
        viewModel.logAddedSuggestion(suggestion)
        addHourBlock()
    }
    
    /// Adds a given title as an Hour Block after checking if it isn't empty.
    private func addHourBlock() {
        if !hourBlockTitle.isEmpty {
            onNewBlockAdded(HourBlock(day: day, hour: hour, title: hourBlockTitle))
            dismiss()
        } else {
            HapticsGateway.shared.triggerErrorHaptic()
        }
    }
    
    /// Dismisses the current view.
    private func dismiss() {
        isPresented = false
    }
}

struct AddHourBlockView_Previews: PreviewProvider {
    static var previews: some View {
        AddHourBlockView(isPresented: .constant(true),
                         for: Date(), 5,
                         onNewBlockAdded: { _ in })
    }
}
