//
//  ToDoListViewModel.swift
//  neon
//
//  Created by James Saeed on 09/02/2020.
//  Copyright © 2020 James Saeed. All rights reserved.
//

import SwiftUI

class ToDoListViewModel: ObservableObject {
    
    @Published var toDoItems = [ToDoItem]()
    
    init() {
        let loadedToDoItems = DataGateway.shared.getToDoEntities().compactMap({ ToDoItem(fromEntity: $0) })
        toDoItems = loadedToDoItems
    }
    
    func addToDoItem(with title: String, _ urgency: ToDoUrgency) {
        let toDoItem = ToDoItem(title: title, urgency: urgency)
        
        DispatchQueue.main.async { self.toDoItems.append(toDoItem) }
        DataGateway.shared.saveToDo(toDo: toDoItem)
    }
    
    func renameToDoItem(toDo: ToDoItem, newTitle: String) {
        if let index = toDoItems.firstIndex(where: { $0.id == toDo.id }) {
            DispatchQueue.main.async { self.toDoItems[index].title = newTitle }
        }
        DataGateway.shared.editToDo(toDo: toDo, set: newTitle, forKey: "title")
    }
    
    func changeToDoItemUrgency(toDo: ToDoItem, newUrgency: ToDoUrgency) {
        if let index = toDoItems.firstIndex(where: { $0.id == toDo.id }) {
            DispatchQueue.main.async { self.toDoItems[index].urgency = newUrgency }
        }
        DataGateway.shared.editToDo(toDo: toDo, set: newUrgency.rawValue, forKey: "urgency")
    }
    
    func removeToDoItem(toDo: ToDoItem) {
        DispatchQueue.main.async { self.toDoItems.removeAll(where: { $0.id == toDo.id }) }
        DataGateway.shared.deleteToDo(toDo: toDo)
    }
}
