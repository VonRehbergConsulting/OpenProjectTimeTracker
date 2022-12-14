//
//  Coordinator.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var finishFlow: (() -> Void)? { get set }
    
    func start()
}
