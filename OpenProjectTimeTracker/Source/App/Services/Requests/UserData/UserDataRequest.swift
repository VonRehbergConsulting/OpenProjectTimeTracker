//
//  UserRequest.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct UserDataRequest: RequestProtocol {
    
    var url: String = OpenProjectEndpoints.userData.reference
    var method: HTTPMethod = .get
    var parameters: [String : Any] = [:]
    var headers: [String : String]  = [:]
    var body: Data? = nil
}
