//
//  TimeEntriesListRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct TimeEntriesListRequest: RequestProtocol {
    
    private let pageSize = 20
    
    var url: String = OpenProjectEndpoints.timeEntries.reference
    var method: HTTPMethod = .get
    var parameters: [String : Any]
    var headers: [String : String] = [:]
    var body: Data? = nil
    
    init(userID: Int, page: Int, date: Date) {
        let dateString = TimeEntryFormatter.formatDate(date)
        parameters = [
            "filters": "[{\"user\":{\"operator\":\"=\",\"values\":[\"\(userID)\"]}}, {\"spent_on\":{\"operator\":\"=d\",\"values\":[\"\(dateString)\"]}}]",
            "pageSize": pageSize,
            "offset": page
        ]
    }
}
