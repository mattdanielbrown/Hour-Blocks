//
//  ToDoViewController.swift
//  neon
//
//  Created by James Saeed on 13/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {
	
	var items = [ToDoItem]() {
		didSet {
			items = items.sorted().reversed()
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		items.append(ToDoItem(title: "Hire a plumber", priority: .high))
		items.append(ToDoItem(title: "Sort Charlie's room", priority: .low))
		items.append(ToDoItem(title: "Redesign website", priority: .medium))
		items.append(ToDoItem(title: "Export clips for Illusions", priority: .medium))
		items.append(ToDoItem(title: "Buy interview prep books", priority: .low))
		items.append(ToDoItem(title: "Edit New Orleans vlog", priority: .none))
		items.append(ToDoItem(title: "Write internship blog post", priority: .medium))
		items.append(ToDoItem(title: "Reconfirm Prime student", priority: .high))
    }
	
	@IBAction func swipedLeft(_ sender: Any) {
		tabBarController?.selectedIndex = 1
	}
}

extension ToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toDoBlockCell", for: indexPath) as? ToDoBlockCell else { return UICollectionViewCell() }
		cell.build(with: items[indexPath.row])
		return cell
	}
}

