//
//  TimeEntryUpdateRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct TimeEntryUpdateRequest: RequestProtocol {
    
    // MARK: - Request model
    
    private struct Model: Codable {
        var hours: String
        var comment: Comment?
        
        init(duration: Date, comment: String?) {
            self.hours = TimeEntryFormatter.formatDuration(duration)
            if let comment = comment {
                self.comment = Comment(raw: comment)
            }
        }
    }
    
    // MARK: - RequestProtocol
    
    var url: String = OpenProjectEndpoints.timeEntries.reference
    var method: HTTPMethod = .patch
    var parameters: [String : Any] = [:]
    var headers: [String : String] = [ "Content-Type": "application/json" ]
    var body: Data?
    
    init(id: Int, duration: Date, comment: String?) {
        url.append(contentsOf: "/\(id)")
        let model = Model(duration: duration, comment: comment)
        body = try? JSONEncoder().encode(model)
    }
}
