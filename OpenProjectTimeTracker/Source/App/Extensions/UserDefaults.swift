//
//  UserDefaults.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 29.08.22.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func object(forKey defaultName: String) -> Any?
}

extension UserDefaults: UserDefaultsProtocol {}
