//
//  OAuth2Swift.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation
import OAuthSwift
import UIKit

protocol OAuth2SwiftProtocol {
    
    @discardableResult
    func authorize(withCallbackURL url: URLConvertible, scope: String, state: String, codeChallenge: String, codeChallengeMethod: String, codeVerifier: String, parameters: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, completionHandler completion: @escaping OAuthSwift.TokenCompletionHandler) -> OAuthSwiftRequestHandle?
    
    @discardableResult
    func renewAccessToken(withRefreshToken refreshToken: String, parameters: OAuthSwift.Parameters?, headers: OAuthSwift.Headers?, completionHandler completion: @escaping OAuthSwift.TokenCompletionHandler) -> OAuthSwiftRequestHandle?
    
    @discardableResult
    func startAuthorizedRequest(_ url: URLConvertible, method: OAuthSwiftHTTPRequest.Method, parameters: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, renewHeaders: OAuthSwift.Headers?, body: Data?, onTokenRenewal: OAuthSwift.TokenRenewedHandler?, completionHandler completion: @escaping OAuthSwiftHTTPRequest.CompletionHandler) -> OAuthSwiftRequestHandle?
}

extension OAuth2Swift: OAuth2SwiftProtocol {
    
    convenience init(viewController: UIViewController) {
        self.init(
            consumerKey: APIKey.consumerKey,
            consumerSecret: "",
            authorizeUrl: APIKey.authorizeURL,
            accessTokenUrl: APIKey.tokenURL,
            responseType: "code",
            contentType: ""
        )
        allowMissingStateCheck = true
        let handler = SafariURLHandler(viewController: viewController, oauthSwift: self)
        authorizeURLHandler = handler
    }
}
