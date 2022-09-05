//
//  LaunchScreenFactoryMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import UIKit

final class LaunchScreenFactoryMock: LaunchScreenFactoryProtocol {
    
    var launchScreen = LaunchViewController()
    func createLaunchScreen() -> LaunchViewController {
        launchScreen
    }
}
