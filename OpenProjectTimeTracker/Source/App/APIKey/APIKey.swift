//
//  APIKey.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import Foundation

struct APIKey: Codable {
    
    let consumerKey: String
    let consumerSecret: String
    let authorizeURL: String
    let tokenURL: String
    
    static var zero: APIKey {
        return .init(consumerKey: "", consumerSecret: "", authorizeURL: "http://localhost", tokenURL: "http://localhost")
    }
    
}
