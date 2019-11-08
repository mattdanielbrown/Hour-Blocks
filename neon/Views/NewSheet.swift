//
//  NewBlockView.swift
//  neon3
//
//  Created by James Saeed on 23/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI

// MARK: - New Block View

struct NewBlockView: View {
    
    @Binding var isPresented: Bool
    @Binding var title: String
    
    let formattedTime: String
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NewTextField(title: $title)
                Text("Suggestions")
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    .padding(.leading, 24)
                List {
                    SuggestionCard(suggestedDomain: DomainsGateway.shared.gym, reason: "popular", didAddBlock: { title in
                        self.addBlock(with: title)
                    })
                }
                Spacer()
            }
            .navigationBarTitle(formattedTime.lowercased())
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    self.addBlock(with: self.title)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addBlock(with title: String) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        isPresented = false
        didAddBlock(title)
    }
}

struct SuggestionCard: View {
    
    let suggestedDomain: BlockDomain
    let reason: String
    
    var didAddBlock: (String) -> ()
    
    var body: some View {
        ZStack {
            Card()
            HStack {
                CardLabels(title: suggestedDomain.suggestionTitle,
                           subtitle: reason.uppercased())
                Spacer()
                Image("add_button")
                .onTapGesture {
                    self.didAddBlock(self.suggestedDomain.suggestionTitle)
                }
            }.padding(EdgeInsets(top: 18, leading: 22, bottom: 18, trailing: 24))
        }.padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
    }
}

// MARK: - New Future Block View

struct NewFutureBlockView: View {
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    @State var date = Date()
    
    var didAddBlock: (String, Date) -> ()
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let max = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        return min...max
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NewTextField(title: $title)
                DatePicker("", selection: $date, in: dateClosedRange)
                Spacer()
            }
            .navigationBarTitle("What's in the future?")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.isPresented = false
                    self.didAddBlock(self.title, self.date)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: New To Do Item View

struct NewToDoItemView: View {
    
    @Binding var isPresented: Bool
    
    @State var title = ""
    @State var priority: ToDoPriority = .none
    
    var didAddToDoItem: (String, ToDoPriority) -> ()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NewTextField(title: $title)
                Picker("", selection: $priority) {
                    Text(ToDoPriority.high.rawValue)
                    Text(ToDoPriority.medium.rawValue)
                    Text(ToDoPriority.low.rawValue)
                    Text(ToDoPriority.none.rawValue)
                }
                Spacer()
            }
            .navigationBarTitle("What's on your list?")
            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if self.title.isEmpty {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    self.isPresented = false
                    self.didAddToDoItem(self.title, self.priority)
                }
            }, label: {
                Text("Add")
            }))
        }.accentColor(Color("primary"))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct NewTextField: View {
    
    @Binding var title: String
    
    var body: some View {
        ZStack() {
            Rectangle()
                .frame(height: 44)
                .foregroundColor(Color("secondary"))
                .cornerRadius(8)
            TextField("Enter the title here...", text: $title)
                .font(.system(size: 17, weight: .medium, design: .default))
                .foregroundColor(Color.black)
                .padding(.horizontal, 16)
        }.padding(24)
    }
}