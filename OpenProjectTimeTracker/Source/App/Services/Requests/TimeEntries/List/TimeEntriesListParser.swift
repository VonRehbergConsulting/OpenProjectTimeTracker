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
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            print(json)
        }
        return []
//           let embedded = json["_embedded"] as? [String: Any],
//           let elements = embedded["elements"] as? [[String: Any]]
//        {
//            var items = [TimeEntry]()
//            for element in elements {
//
//            }
//        }
    }
}
