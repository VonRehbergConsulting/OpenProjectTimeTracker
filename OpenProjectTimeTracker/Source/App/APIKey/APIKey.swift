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
    
    static var openProject: APIKey {
        guard let path = Bundle.main.path(forResource: "OpenProjectKey", ofType: "plist")
        else {
            Logger.log(event: .error, "Can't find API key file")
            return .zero
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url),
              let result = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else {
            Logger.log(event: .error, "Can't read API key file")
            return .zero
        }
        return result
    }
    
}
