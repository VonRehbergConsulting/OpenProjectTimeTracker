//
//  OAuth2SwiftProtocolMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import OAuthSwift
import Foundation

final class OAuth2SwiftProtocolMock: OAuth2SwiftProtocol {
    
    var authorizeStub: Result<OAuthSwift.TokenSuccess, OAuthSwiftError>?
    func authorize(withCallbackURL url:  URLConvertible, scope: String, state: String, codeChallenge: String, codeChallengeMethod: String, codeVerifier: String, parameters: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, completionHandler completion: @escaping OAuthSwift.TokenCompletionHandler) -> OAuthSwiftRequestHandle? {
        guard let authorizeStub = authorizeStub else { return nil }
        completion(authorizeStub)
        return nil
    }
    
    var reniewAccessTokenStub: Result<OAuthSwift.TokenSuccess, OAuthSwiftError>?
    func renewAccessToken(withRefreshToken refreshToken: String, parameters: OAuthSwift.Parameters?, headers: OAuthSwift.Headers?, completionHandler completion: @escaping OAuthSwift.TokenCompletionHandler) -> OAuthSwiftRequestHandle? {
        guard let reniewAccessTokenStub = reniewAccessTokenStub else { return nil }
        completion(reniewAccessTokenStub)
        return nil
    }
    
    var onTokenRenewalStub: Result<OAuthSwiftCredential, Never>?
    var startAuthorizedRequestStub: Result<OAuthSwiftResponse, OAuthSwiftError>?
    func startAuthorizedRequest(_ url: URLConvertible, method: OAuthSwiftHTTPRequest.Method, parameters: OAuthSwift.Parameters, headers: OAuthSwift.Headers?, renewHeaders: OAuthSwift.Headers?, body: Data?, onTokenRenewal: OAuthSwift.TokenRenewedHandler?, completionHandler completion: @escaping OAuthSwiftHTTPRequest.CompletionHandler) -> OAuthSwiftRequestHandle? {
        if let onTokenRenewalStub = onTokenRenewalStub {
            onTokenRenewal?(onTokenRenewalStub)
        }
        guard let startAuthorizedRequestStub = startAuthorizedRequestStub else { return nil }
        completion(startAuthorizedRequestStub)
        return nil
    }
    
}
