//
//  ContentView.swift
//  neon3
//
//  Created by James Saeed on 18/06/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var selection = 0
    
    @State var showWhatsNew = false
    
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().allowsSelection = false
        UITableView.appearance().showsVerticalScrollIndicator = false
        UITableViewCell.appearance().selectionStyle = .none
    }
 
    var body: some View {
        TabView {
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Schedule")
                }
                .onAppear(perform: {
                    self.showWhatsNew = DataGateway.shared.isNewVersion()
//                    self.showWhatsNew = true
                })
                .sheet(isPresented: $showWhatsNew, content: {
                    WhatsNewView(showWhatsNew: self.$showWhatsNew)
                })
            HabitsView()
                .tabItem {
                    Image(systemName: "flame")
                    Text("Habits")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }.accentColor(Color("primary"))
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif