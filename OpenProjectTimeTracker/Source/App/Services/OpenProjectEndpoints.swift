//
//  OpenProjectEndpoints.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation

enum OpenProjectEndpoints {
    
    // MARK: - Plist struct
    
    private struct EndpointPlist: Codable {
        var userData: String
        var tasks: String
        var timeEntries: String
    }
    
    // MARK: - Cases
    
    case userData
    case tasks
    case timeEntries
    
    var reference: String {
        guard let result = PlistReader<EndpointPlist>().read(from: "OpenProjectEndpoints") else {
            Logger.log(event: .error, "Can't find API endpoints")
            return ""
        }
        var reference = APIKey.apiURL
        switch self {
        case .userData:
            reference += result.userData
        case .tasks:
            reference += result.tasks
        case .timeEntries:
            reference += result.timeEntries
        }
        return reference
    }
}
