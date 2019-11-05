//
//  Coordinator.swift
//  baby ketten
//
//  Created by Christopher Schepman on 8/11/19.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
