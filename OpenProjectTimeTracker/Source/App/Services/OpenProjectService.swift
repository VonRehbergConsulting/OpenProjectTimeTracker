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
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, _ completion: @escaping (Result<Parser.Model, Error>) -> Void)
}

// MARK: - HTTPMethod

enum HTTPMethod {
    case get
    case post
    case patch
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
                if let errorCode = (error.errorUserInfo["error"] as? NSError)?.code {
                    switch errorCode {
                    case -1004, -1001, -1005, 503, 500:
                        completion(.failure(NetworkError.noConnection))
                    case 400:
                        completion(.failure(NetworkError.unanthorized))
                    default:
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - RequestServiceProtocol
    
    func send<Parser>(requestConfig: RequestConfig<Parser>, _ completion: @escaping (Result<Parser.Model, Error>) -> Void) {
        var oauthMethod: OAuthSwiftHTTPRequest.Method
        switch requestConfig.request.method {
        case .get:
            oauthMethod = .GET
        case .post:
            oauthMethod = .POST
        case .patch:
            oauthMethod = .PATCH
        }
        // TODO: implement error handling on token renewal
        oauth2swift.startAuthorizedRequest(requestConfig.request.url,
                                           method: oauthMethod,
                                           parameters: requestConfig.request.parameters,
                                           headers: requestConfig.request.headers,
                                           body: requestConfig.request.body,
                                           onTokenRenewal: { [weak self] result in
            switch result {
            case .success(let credentials):
                self?.tokenStorage.token = AuthorizationToken(oauthToken: credentials.oauthToken, refreshToken: credentials.oauthRefreshToken)
            case .failure(_):
                Logger.log(event: .warning, "Cannot refresh token")
            }

        }, completionHandler: { result in
            switch result {
            case .success(let (response)):
                if let parsedData = requestConfig.parser.parse(response.data) {
                    completion(.success(parsedData))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
