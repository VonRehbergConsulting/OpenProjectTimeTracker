//
//  URLHandler.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import Foundation
import OAuthSwift

protocol URLHandlerProtocol {
    
    func handle(_ url: URL)
}

class URLHandler<OAuth: OAuthSwiftProtocol>: URLHandlerProtocol {
    
    // MARK: - URLHandlerProtocol
    
    func handle(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
//        let scheme = components.scheme
        let host = components.host
//        let path = components.path
        
//        let queryItems = components.queryItems ?? []
//        let parameters = queryItems.compactMap { [$0.name: $0.value ?? ""] }
        
        Logger.log(event: .transition, "Transition from deeplink, URL: \(url)")

        switch host {
        case "oauth-callback":
            OAuth.handle(url: url)
        default:
            Logger.log(event: .warning, "Deeplink was not handled")
        }
    }
}
