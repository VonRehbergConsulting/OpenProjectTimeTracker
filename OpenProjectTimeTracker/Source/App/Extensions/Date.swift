//
//  Date.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
