//
//  DateComponents.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

extension DateComponents {
    
    var timeInterval: TimeInterval {
        let calendar = Calendar.current
        let date = Date()
        guard let increasedDate = calendar.date(byAdding: self, to: date) else {
            Logger.log(event: .error, "Can't calculate time interval")
            return TimeInterval()
        }
        return increasedDate - date
    }
    
    var clockTime: String {
        let hoursStr = processNumber(hour)
        let minutesStr = processNumber(minute)
        let secondsStr = processNumber(second)
        return "\(hoursStr):\(minutesStr):\(secondsStr)"
    }
    
    var shortClockTime: String {
        let hoursStr = processNumber(hour)
        let minutesStr = processNumber(minute)
        return "\(hoursStr):\(minutesStr)"
    }
    
    // MARK: - Private helpers
    
    private func processNumber(_ number: Int?) -> String {
        guard let number = number else { return "00" }
        if number < 10 { return "0\(number)" }
        return number.description
    }
}
