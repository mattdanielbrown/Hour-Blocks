//
//  TestGateway.swift
//  neon
//
//  Created by James Saeed on 25/03/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import Foundation
import CloudKit

class DataGateway {
    
    static let shared = DataGateway()
    
    func fetchCurrentAgendaItem(completion: @escaping (_ currentAgendaItem: AgendaItem?) -> ()) {
        if CalendarGateway.shared.hasPermission() {
            for event in CalendarGateway.shared.importTodaysEvents() {
                for i in event.startTime...event.endTime {
                    if i == Calendar.current.component(.hour, from: Date()) {
                        completion(AgendaItem(title: event.title))
                        return
                    }
                }
            }
        }
        
        let database = CKContainer(identifier: "iCloud.com.evh98.neon").privateCloudDatabase
        let query = CKQuery(recordType: "AgendaRecord", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            records?.forEach({ (record) in
                guard let id = record.value(forKey: "id") as? String else { return }
                guard let hour = record.value(forKey: "hour") as? Int else { return }
                guard let title = record.value(forKey: "title") as? String else { return }
                guard let day = record.value(forKey: "day") as? Date else { return }
                
                // Only pull the tasks that are in today and aren't already on device
                if Calendar.current.isDateInToday(day) && hour == Calendar.current.component(.hour, from: Date()) {
                    completion(AgendaItem(with: id, and: title))
                    return
                }
            })
        }
        
        completion(nil)
    }
}
