//
//  TimeEntriesRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct TimeEntriesCreateRequest: RequestProtocol {
    
    // MARK: - Request model
    
    private struct Model: Codable {
        
        struct User: Codable {
            var id: String
        }
        
        struct Project: Codable {
            var href: String
        }
        
        struct WorkPackage: Codable {
            var href: String
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
            hours = TimeEntryFormatter.formatDuration(timeSpent)
            spentOn = TimeEntryFormatter.formatDate(date)
        }
    }
    
    // MARK: - RequestProtocol
    
    var url: String = OpenProjectEndpoints.timeEntries.reference
    var method: HTTPMethod = .post
    var parameters: [String : Any] = [:]
    var headers: [String : String] = [ "Content-Type": "application/json" ]
    var body: Data?
    
    init(userID: Int,
         projectHref: String,
         workPackageHref: String,
         duration: Date,
         date: Date,
         comment: String?
    ) {
        let timeEntry = Model(
            userID: userID,
            taskHref: workPackageHref,
            projectHref: projectHref,
            timeSpent: duration,
            date: date,
            comment: comment
        )
        body = try? JSONEncoder().encode(timeEntry)
    }
}
