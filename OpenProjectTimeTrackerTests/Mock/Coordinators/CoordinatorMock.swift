//
//  CoordinatorMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker

final class CoordinatorMock: Coordinator {
    
    var finishFlow: (() -> Void)?
    
    var startCalled = false
    func start() {
        startCalled = true
    }
}
