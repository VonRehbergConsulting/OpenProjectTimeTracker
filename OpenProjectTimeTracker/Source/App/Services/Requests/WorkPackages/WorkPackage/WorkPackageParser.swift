//
//  WorkPackageParser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

final class WorkPackageParser: ParserProtocol {
    
    typealias Model = Task
    
    func parse(_ data: Data) -> Task? {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let subject = json["subject"] as? String,
           let links = json["_links"] as? [String: Any],
           let project = links["project"] as? [String: Any],
           let projectHref = project["href"] as? String,
           let self = links["self"] as? [String: Any],
           let selfHref = self["href"] as? String
        {
            let projectTitle = project["title"] as? String
            var priorityTitle: String?
            if let priority = links["priority"] as? [String: Any]
            {
                priorityTitle = priority["title"] as? String
            }
            var statusTitle: String?
            if let status = links["status"] as? [String: Any]
            {
                statusTitle = status["title"] as? String
            }
            
            let task = Task(
                selfHref: selfHref,
                subject: subject,
                projectHref: projectHref,
                projectTitle: projectTitle,
                prioriry: priorityTitle,
                status: statusTitle)
            return task
        }
        return nil

    }
}
