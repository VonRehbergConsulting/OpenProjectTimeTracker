//
//  WorkPackagesRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct WorkPackagesRequest: RequestProtocol {
    
    private let pageSize = 20
    
    var url = OpenProjectEndpoints.tasks.reference
    var method: HTTPMethod = .get
    var parameters: [String : Any]
    var headers: [String : String] = [:]
    var body: Data? = nil
    
    init(userID: Int, page: Int) {
        parameters = [
            "filters": "[{\"assignee\":{\"operator\":\"=\",\"values\":[\"\(userID)\"]}}, {\"status\":{\"operator\":\"!\",\"values\":[\"12\"]}}]",
            "pageSize": pageSize,
            "offset": page
        ]
        
    }
    
}
