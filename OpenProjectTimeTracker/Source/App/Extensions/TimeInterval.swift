//
//  TimeInterval.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 11.10.22.
//

import Foundation

extension TimeInterval {
    
    var shortClockTime: String {
        let time = Int(self)
        let hour = Int(time / 3600)
        let minute = (time - hour * 3600) / 60
        let hoursStr = processNumber(hour)
        let minutesStr = processNumber(minute)
        return "\(hoursStr):\(minutesStr)"
    }
    
    // MARK: - Private helpers
    
    private func processNumber(_ number: Int?) -> String {
        guard let number = number else { return "00" }
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        return formatter.string(from: number as NSNumber) ?? "00"
    }
}
