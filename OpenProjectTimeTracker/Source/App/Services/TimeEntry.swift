//
//  TimeEntry.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import Foundation

struct TimeEntry: Codable {
    
    struct User: Codable {
        var id: String = "5"
    }
    
    struct Project: Codable {
        var href: String = "/api/v3/projects/1"
    }
    
    struct WorkPackage: Codable {
        var href: String = "/api/v3/work_packages/4"
    }
    
    struct Comment: Codable {
        var format: String =  "plain"
        var raw: String =  "Some comment from the app"
    }
    
    var hours: String = "PT2H"
    var comment: Comment = Comment()
    var spentOn: String = "2022-08-09"
    var user: User = User()
    var project: Project = Project()
    var workPackage: WorkPackage = WorkPackage()
    
}
