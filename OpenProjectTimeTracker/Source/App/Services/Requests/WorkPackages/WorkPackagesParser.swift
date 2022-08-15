//
//  WorkPackagesParser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

class WorkPackagesParser: ParserProtocol {
    
    typealias Model = [Task]
    
    func parse(_ data: Data) -> [Task]? {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let embedded = json["_embedded"] as? [String: Any],
           let elements = embedded["elements"] as? [[String: Any]]
        {
            var tasks = [Task]()
            for element in elements {
                if let subject = element["subject"] as? String,
                   let links = element["_links"] as? [String: Any],
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
                    tasks.append(task)
                }
            }
            return tasks
        }
        return nil
    }
}
