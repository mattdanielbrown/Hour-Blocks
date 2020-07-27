//
//  NewAddToDoItemView.swift
//  Hour Blocks
//
//  Created by James Saeed on 19/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewAddToDoItemView: View {
    
    @ObservedObject var viewModel: NewToDoListViewModel
    
    @State var title = ""
    @State var urgency: ToDoUrgency = .whenever
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack(spacing: 16) {
                    NewNeonTextField(input: $title,
                                     didReturn: addToDoItem)
                    NewIconButton(iconName: "plus",
                                  iconWeight: .bold,
                                  action: addToDoItem)
                }.padding(24)
                
                Text("Urgency")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .padding(.leading, 24)
                Picker("", selection: $urgency) {
                    Text("Whenever").tag(ToDoUrgency.whenever)
                    Text("Soon").tag(ToDoUrgency.soon)
                    Text("Urgent").tag(ToDoUrgency.urgent)
                }.pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 24)
                
                Spacer()
            }.navigationTitle("Add a To Do Item")
            .navigationBarItems(leading: Button("Cancel", action: dismiss))
        }
        .accentColor(Color("AccentColor"))
    }
    
    func addToDoItem() {
        viewModel.add(toDoItem: ToDoItem(title: title, urgency: urgency))
        dismiss()
    }
    
    func dismiss() {
        viewModel.dismissAddToDoItemView()
    }
}

struct NewAddToDoItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddToDoItemView(viewModel: NewToDoListViewModel())
    }
}
