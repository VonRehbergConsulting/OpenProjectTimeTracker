//
//  Task.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

struct Task: Codable {
    
    var selfHref: String
    var subject: String
    
    var projectHref: String
    var projectTitle: String?
    var prioriry: String?
    var status: String?
}
