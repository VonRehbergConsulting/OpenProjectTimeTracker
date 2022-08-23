//
//  APIKey.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import Foundation

struct APIKey {
    
    static var consumerKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_PROJECT_CONSUMER_KEY") as? String ?? ""
    static var authorizeURL: String = {
        if let authorizeURL = Bundle.main.object(forInfoDictionaryKey: "OPEN_PROJECT_AUTHORIZE_URL") as? String {
            return fixURLCharacters(authorizeURL)
        } else {
            return "http://localhost"
        }
    }()
    static var tokenURL: String = {
        if let tokenURL = Bundle.main.object(forInfoDictionaryKey: "OPEN_PROJECT_TOKEN_URL") as? String {
            return fixURLCharacters(tokenURL)
        } else {
            return "http://localhost"
        }
    }()
    static var apiURL: String = {
        if let apiURL = Bundle.main.object(forInfoDictionaryKey: "OPEN_PROJECT_API_URL") as? String {
            return fixURLCharacters(apiURL)
        } else {
            return "http://localhost"
        }
    }()
    
    // MARK: - Private helpers
    
    static func fixURLCharacters(_ url: String) -> String {
        return url.replacingOccurrences(of: "|", with: "/")
    }
}
