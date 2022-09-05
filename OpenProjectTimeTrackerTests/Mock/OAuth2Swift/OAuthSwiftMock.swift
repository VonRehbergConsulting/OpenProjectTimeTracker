//
//  OAuthSwiftMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 02.09.22.
//

@testable import OpenProjectTimeTracker
import Foundation

final class OAuthSwiftMock: OAuthSwiftProtocol {
    
    static var handleCalled = false
    static func handle(url: URL) {
        handleCalled = true
    }
}
