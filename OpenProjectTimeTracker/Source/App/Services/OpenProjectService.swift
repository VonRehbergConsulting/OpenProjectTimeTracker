//
//  OpenProjectService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import OAuthSwift
import UIKit

// MARK: - Service protocols

protocol AuthorizationServiceProtocol: AnyObject {
    
    var viewController: UIViewController? { get set }
    
    func authorize(_ completion: @escaping ((Result<AuthorizationToken, Error>) -> Void))
}

protocol RefreshTokenServiceProtocol: AnyObject {
    
    func refresh(_ token: AuthorizationToken, completion: @escaping (Result<AuthorizationToken, Error>) -> Void)
}

protocol RequestServiceProtocol: AnyObject {
    
    func request(_ url: String, method: HTTPMethod, parameters: [String: Any], _ completion: @escaping ((Result<Data, Error>) -> Void))
}

// MARK: - HTTPMethod

enum HTTPMethod {
    case get
    case post
}

// MARK: - OpenProjectService

class OpenProjectService: AuthorizationServiceProtocol,
                          RefreshTokenServiceProtocol,
                          RequestServiceProtocol {
    
    // MARK: - Properties
    
    private let apiKey: APIKey
    
    private lazy var oauth2swift: OAuth2Swift = {
        let oauth2swift = OAuth2Swift(apiKey)
        
        if let viewController = viewController {
            let handler = SafariURLHandler(viewController: viewController, oauthSwift: oauth2swift)
            oauth2swift.authorizeURLHandler = handler
        } else {
            Logger.log(event: .warning, "Can't find view controller for authorization service")
        }
        
        return oauth2swift
    }()
    
    let tokenStorage: TokenStorageProtocol
    
    weak var viewController: UIViewController?
    
    // MARK: - Lifecycle
    
    init(apiKey: APIKey,
         tokenStorage: TokenStorageProtocol) {
        self.apiKey = apiKey
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - AuthorizationServiceProtocol
    
    func authorize(_ completion: @escaping ((Result<AuthorizationToken, Error>) -> Void)) {
        
        Logger.log("Sending authorization request")
        
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
    
    // MARK: - RefreshTokenProtocol
    
    func refresh(_ token: AuthorizationToken, completion: @escaping (Result<AuthorizationToken, Error>) -> Void) {
        oauth2swift.renewAccessToken(withRefreshToken: token.refreshToken) { result in
            switch result {
            case .success(let (credential, _, _)):
                let token = AuthorizationToken(
                    oauthToken: credential.oauthToken,
                    refreshToken: credential.oauthRefreshToken
                )
                Logger.log(event: .success, "Token refresh succeded")
                completion(.success(token))
            case .failure(let error):
                Logger.log(event: .failure, "Token refresh failed: " + error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - RequestServiceProtocol
    
    func request(_ url: String, method: HTTPMethod, parameters: [String: Any] = [:], _ completion: @escaping ((Result<Data, Error>) -> Void)) {
        
        var oauthMethod: OAuthSwiftHTTPRequest.Method
        switch method {
        case .get:
            oauthMethod = .GET
        case .post:
            oauthMethod = .POST
        }
        
        // TODO: implement token renewal
        oauth2swift.startAuthorizedRequest(url,
                                           method: oauthMethod,
                                           parameters: parameters,
                                           onTokenRenewal: { _ in
        }, completionHandler: { result in
            switch result {
            case .success(let (response)):
                completion(.success(response.data))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        })
    }
}
