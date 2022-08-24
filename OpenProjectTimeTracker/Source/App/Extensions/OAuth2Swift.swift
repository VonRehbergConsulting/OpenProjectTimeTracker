//
//  OAuth2Swift.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import OAuthSwift

extension OAuth2Swift {
    
    static var openProject: OAuth2Swift {
        let oauth2swift = OAuth2Swift(
            consumerKey: APIKey.consumerKey,
            consumerSecret: "",
            authorizeUrl: APIKey.authorizeURL,
            accessTokenUrl: APIKey.tokenURL,
            responseType: "code",
            contentType: ""
        )
        oauth2swift.allowMissingStateCheck = true
        return oauth2swift
    }
}
