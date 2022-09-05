//
//  AuthorizationToken.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import Foundation

struct AuthorizationToken: Codable, Equatable {
    
    var oauthToken: String
    var refreshToken: String
}
