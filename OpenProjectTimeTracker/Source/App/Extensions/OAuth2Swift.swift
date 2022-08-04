//
//  OAuth2Swift.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import OAuthSwift

extension OAuth2Swift {
    
    convenience init(_ apiKey: APIKey) {
        self.init(
            consumerKey: apiKey.consumerKey,
            consumerSecret: apiKey.consumerSecret,
            authorizeUrl: apiKey.authorizeURL,
            accessTokenUrl: apiKey.tokenURL,
            responseType: "code",
            contentType: ""
        )
        allowMissingStateCheck = true
    }
}
