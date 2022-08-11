//
//  Logger.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import Foundation

enum LogEvent: String {
    case error = "‼️"
    case warning = "⚠️"
    case transition = "🔗"
    case info = "ℹ️"
    case success = "✅"
    case failure = "❌"
}

class Logger {
    
    // MARK: - Properties
    
    static var isDetailed = true
    static var isLoggingEnabled = true
    
    // MARK: - Methods
    
    class func log(
        event: LogEvent = .info,
        _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        function: String = #function
    ) {
        if isLoggingEnabled {
            let message = "\(logData(logEvent: event, filename: filename, line: line, column: column, function: function)): \(object)"
            print(message)
        }
    }
    
    // MARK: - Private helpers
    
    private class func logData(
        logEvent: LogEvent,
        filename: String,
        line: Int,
        column: Int,
        function: String
    ) -> String {
        var message = "\(formatDate(Date())) [\(logEvent.rawValue)]"
        if isDetailed {
            message += "[\(filename)] \(line) \(column) \(function)"
        }
        return message
    }
    
    private class func formatDate(_ date: Date) -> String {
        let dateFormat = "yyyy-MM-dd hh:mm:ss"
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: date)
    }
}
