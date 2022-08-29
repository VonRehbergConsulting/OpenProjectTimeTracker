//
//  CoordinatorRouterMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import UIKit

final class CoordinatorRouterMock: CoordinatorRouterProtocol {
    
    var transitionCalled = false
    func transition(to viewController: UIViewController) {
        transitionCalled = true
    }
    
    var pushCalled = false
    func push(_ viewController: UIViewController, animated: Bool) {
        pushCalled = true
    }
    
    var popCalled = false
    func pop(animated: Bool) {
        popCalled = true
    }
}
