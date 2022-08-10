//
//  TimeEntriesService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

protocol TimeEntriesServiceProtocol {
    
    func createTimeEntry(userID: Int,
                         projectHref: String,
                         workPackageHref: String,
                         duration: Date,
                         date: Date,
                         comment: String?,
                         _ completion: @escaping ((Bool) -> Void))
    
}

final class TimeEntriesService: TimeEntriesServiceProtocol {
    
    // MARK: - Request model
    
    private struct TimeEntry: Codable {
        
        struct User: Codable {
            var id: String
        }
        
        struct Project: Codable {
            var href: String
        }
        
        struct WorkPackage: Codable {
            var href: String
        }
        
        struct Comment: Codable {
            var format: String =  "plain"
            var raw: String
        }
        
        var hours: String
        var comment: Comment?
        var spentOn: String
        var user: User
        var project: Project
        var workPackage: WorkPackage
        
        init(userID: Int,
             taskHref: String,
             projectHref: String,
             timeSpent: Date,
             date: Date,
             comment: String?) {
            user = User(id: String(userID))
            workPackage = WorkPackage(href: taskHref)
            project = Project(href: projectHref)
            if let comment = comment {
                self.comment = .init(raw: comment)
            }
            hours = TimeEntry.formatDuration(timeSpent)
            spentOn = TimeEntry.formatDate(date)
            
        }
        
        private static func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            return dateFormatter.string(from: date)
        }
        
        private static func formatDuration(_ date: Date) -> String {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: date)
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
        
    }
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - TimeEntriesServiceProtocol
    
    func createTimeEntry(userID: Int,
                         projectHref: String,
                         workPackageHref: String,
                         duration: Date,
                         date: Date,
                         comment: String?,
                         _ completion: @escaping ((Bool) -> Void)) {
        let timeEntry = TimeEntry(userID: userID, taskHref: workPackageHref, projectHref: projectHref, timeSpent: duration, date: date, comment: comment)
        let body = try? JSONEncoder().encode(timeEntry)
        let headers: [String: String] = [ "Content-Type": "application/json" ]
        service.request(OpenProjectEndpoints.timeEntries.reference,
                        method: .post,
                        parameters: [:],
                        headers: headers,
                        body: body) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
        
    }
    
}
