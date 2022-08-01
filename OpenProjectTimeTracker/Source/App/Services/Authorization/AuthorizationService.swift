//
//  AuthorizationService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import OAuthSwift
import UIKit

protocol AuthorizationServiceProtocol {
    
    var viewController: UIViewController? { get set }
    
    func authorize(_ completion: @escaping ((Result<AuthorizationToken, Error>) -> Void))
    
}

class AuthorizationService: AuthorizationServiceProtocol {
    
    // MARK: - Properties
    
    let apiKey: APIKey
    
    private lazy var oauth2swift: OAuth2Swift = {
        let oauth2swift = OAuth2Swift(
            consumerKey: apiKey.consumerKey,
            consumerSecret: apiKey.consumerSecret,
            authorizeUrl: apiKey.authorizeURL,
            accessTokenUrl: apiKey.tokenURL,
            responseType: "code",
            contentType: ""
        )
        
        oauth2swift.allowMissingStateCheck = true
        
        if let viewController = viewController {
            let handler = SafariURLHandler(viewController: viewController, oauthSwift: oauth2swift)
            oauth2swift.authorizeURLHandler = handler
        } else {
            Logger.log(event: .warning, "Can't find view controller for authorization service")
        }
        
        return oauth2swift
    }()
    
    weak var viewController: UIViewController?
    
    // MARK: - Lifecycle
    
    init(apiKey: APIKey) {
        self.apiKey = apiKey
    }
    
    // MARK: - AuthorizationServiceProtocol
    
    func authorize(_ completion: @escaping ((Result<AuthorizationToken, Error>) -> Void)) {
        
        Logger.log("Starting authorization")
        
        guard let codeVerifier = generateCodeVerifier(),
              let codeChallenge = generateCodeChallenge(codeVerifier: codeVerifier)
        else {
            Logger.log(event: .error, "Cannon generate core verifier for PKCE")
            return
        }
        
        oauth2swift.authorize(withCallbackURL: "openprojecttimetracker://oauth-callback",
                              scope: "api_v3",
                              state: "",
                              codeChallenge: codeChallenge,
                              codeChallengeMethod: "S256",
                              codeVerifier: codeVerifier
        ) { result in
            switch result {
            case .success(let (credential, _, _)):
                let token = AuthorizationToken(
                    oauthToken: credential.oauthToken,
                    refreshToken: credential.oauthRefreshToken
                )
                Logger.log(event: .success, "Authorization succeded")
                completion(.success(token))
            case .failure(let error):
                Logger.log(event: .failure, "Authorization failed: " + error.localizedDescription)
                Logger.log(event: .failure, error.errorUserInfo)
                completion(.failure(error))
            }
        }
    }
}
