//
//  ScheduleCoordinator.swift
//  neon
//
//  Created by James Saeed on 19/05/2019.
//  Copyright © 2019 James Saeed. All rights reserved.
//

import UIKit

class ScheduleCoordinator: Coordinator {
	
	weak var appCoordinator: AppCoordinator?
	
	var navigationController: UINavigationController
	
	init() {
		// Construct nav bar
		self.navigationController = UINavigationController()
		self.navigationController.navigationBar.isHidden = true
		
		// Initialise and present the schedule screen
		let vc = ScheduleViewController.instantiate()
		vc.coordinator = self
		navigationController.pushViewController(vc, animated: false)
	}
	
	func swipeToToDo() {
		appCoordinator?.swipeToToDo()
	}
	
	func swipeToSettings() {
		appCoordinator?.swipeToSettings()
	}
}
