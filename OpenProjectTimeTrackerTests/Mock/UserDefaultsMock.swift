//
//  UserDefaultsMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker

final class UserDefaultsMock: UserDefaultsProtocol {
    
    var storage: [String: Any?] = [:]
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
    func object(forKey defaultName: String) -> Any? {
        storage[defaultName]
    }
}
