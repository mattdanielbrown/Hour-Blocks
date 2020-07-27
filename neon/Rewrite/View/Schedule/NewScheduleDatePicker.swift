//
//  NewScheduleDatePicker.swift
//  Hour Blocks
//
//  Created by James Saeed on 02/07/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

struct NewScheduleDatePicker: View {
    
    @Binding var isPresented: Bool
    @Binding var scheduleDate: Date
    let dateChanged: () -> Void
    
    @StateObject var viewModel: ScheduleDatePickerViewModel
    
    init(isPresented: Binding<Bool>, scheduleDate: Binding<Date>, dateChanged: @escaping () -> Void) {
        self._isPresented = isPresented
        self._scheduleDate = scheduleDate
        self._viewModel = StateObject<ScheduleDatePickerViewModel>(wrappedValue: ScheduleDatePickerViewModel(initialSelectedDate: scheduleDate.wrappedValue))
        self.dateChanged = dateChanged
    }
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    DatePicker("Picker", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .frame(maxHeight: geometry.size.width)
                        .accentColor(Color("AccentColor"))
                        .onChange(of: viewModel.selectedDate) { _ in
                            viewModel.loadHourBlocks()
                        }
                }.padding(.horizontal, 24)
                .padding(.top, 24)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        ForEach(viewModel.calendarBlocks, id: \.self) { event in
                            CalendarBlockView(event: event)
                        }
                        
                        if !viewModel.calendarBlocks.isEmpty &&
                            !viewModel.hourBlocks.filter { $0.title != "Empty" }.isEmpty {
                            NeonDivider().padding(.horizontal, 32)
                        }
                        
                        ForEach(viewModel.hourBlocks.filter { $0.title != "Empty" } ) { hourBlockViewModel in
                            CompactHourBlockView(viewModel: hourBlockViewModel)
                        }
                        
                        if viewModel.calendarBlocks.isEmpty && viewModel.hourBlocks.filter { $0.title != "Empty" }.isEmpty {
                            NoHourBlocksView()
                        }
                    }.padding(.top, 8)
                    .padding(.bottom, 24)
                }
            }.navigationBarTitle("Date Picker", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: dismiss),
                                trailing: Button("Save", action: save))
        }.accentColor(Color("AccentColor"))
    }
    
    func save() {
        scheduleDate = viewModel.selectedDate
        dateChanged()
        dismiss()
    }
    
    func dismiss() {
        isPresented = false
    }
}
/*
struct NewScheduleDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        NewScheduleDatePicker(isPresented: .constant(true), date: .constant(Date()))
    }
}
*/
