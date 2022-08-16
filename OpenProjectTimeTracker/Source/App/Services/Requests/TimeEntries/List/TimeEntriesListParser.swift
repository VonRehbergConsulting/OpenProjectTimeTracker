//
//  TimeEntriesListParser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

final class TimeEntriesListParser: ParserProtocol {
    
    typealias Model = [TimeEntryListModel]
    
    func parse(_ data: Data) -> [TimeEntryListModel]? {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let embedded = json["_embedded"] as? [String: Any],
           let elements = embedded["elements"] as? [[String: Any]]
        {
            var items = [TimeEntryListModel]()
            for element in elements {
                if let id = element["id"] as? Int,
                   let hours = element["hours"] as? String,
                   let timeSpent = TimeEntryFormatter.decode(hours: hours),
                   let links = element["_links"] as? [String: Any],
                   let project = links["project"] as? [String: Any],
                   let projectTitle = project["title"] as? String,
                   let workPackage = links["workPackage"] as? [String: Any],
                   let workPackageTitle = workPackage["title"] as? String,
                   let workPackageReference = workPackage["href"] as? String,
                   let workPackageIDString = workPackageReference.components(separatedBy: "/").last,
                   let workPackageID = Int(workPackageIDString),
                   let comment = element["comment"] as? [String: Any],
                   let commentRaw = comment["raw"] as? String
                {
                    items.append(.init(id: id,
                                       projectTitle: projectTitle,
                                       workPackageTitle: workPackageTitle,
                                       workPackageID: workPackageID,
                                       timeSpent: timeSpent,
                                       comment: commentRaw))
                }
            }
            return items
        }
        return nil
    }
}
