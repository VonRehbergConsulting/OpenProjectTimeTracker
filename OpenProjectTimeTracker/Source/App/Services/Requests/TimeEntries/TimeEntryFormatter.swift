//
//  TimeEntryFormatter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation
import Swift_ISO8601_DurationParser

final class TimeEntryFormatter {
    
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func formatDuration(_ date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)
        return formatDuration(components)
    }
    
    static func formatDuration(_ components: DateComponents) -> String {
        var result = "PT"
        if let hours = components.hour {
            result.append("\(hours)H")
        }
        if let minutes = components.minute {
            result.append("\(minutes)M")
        }
        if let seconds = components.second {
            result.append("\(seconds)S")
        }
        if result == "PT" { result = "PT0H" }
        return result
    }
    
    static func decode(hours: String) -> DateComponents? {
        return DateComponents.durationFrom8601String(hours)
    }
}
