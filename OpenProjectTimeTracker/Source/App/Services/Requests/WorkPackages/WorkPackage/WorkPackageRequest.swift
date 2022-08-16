//
//  WorkPackageRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

struct WorkPackageRequest: RequestProtocol {
    
    var url = OpenProjectEndpoints.tasks.reference
    var method: HTTPMethod = .get
    var parameters: [String : Any] = [:]
    var headers: [String : String] = [:]
    var body: Data? = nil
    
    init(id: Int) {
        url.append("/\(id)")
    }
}
