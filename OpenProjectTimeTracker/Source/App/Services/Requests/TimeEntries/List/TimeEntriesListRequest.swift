//
//  TimeEntriesListRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct TimeEntriesListRequest: RequestProtocol {
    
    private let pageSize = 40
    
    var url: String = OpenProjectEndpoints.timeEntries.reference
    var method: HTTPMethod = .get
    var parameters: [String : Any]
    var headers: [String : String] = [:]
    var body: Data? = nil
    
    init(userID: Int?, page: Int, date: Date?, workPackage: Int?) {
        var filters: [String] = []
        if let userID = userID { filters.append("{\"user\":{\"operator\":\"=\",\"values\":[\"\(userID)\"]}}") }
        if let date = date {
            let dateString = TimeEntryFormatter.formatDate(date)
            filters.append("{\"spent_on\":{\"operator\":\"=d\",\"values\":[\"\(dateString)\"]}}")
        }
        if let workPackage = workPackage { filters.append("{\"workPackage\":{\"operator\":\"=\",\"values\":[\"\(workPackage)\"]}}") }
        parameters = [
            "filters": "[\(filters.joined(separator: ","))]",
            "pageSize": pageSize,
            "offset": page
        ]
    }
}
