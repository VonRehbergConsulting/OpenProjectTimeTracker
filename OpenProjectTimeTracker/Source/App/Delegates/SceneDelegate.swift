//
//  SceneDelegate.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var apiKey: APIKey {
        guard let path = Bundle.main.path(forResource: "OpenProjectKey", ofType: "plist")
        else {
            Logger.log(event: .error, "Can't find API key file")
            return .zero
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url),
              let result = try? PropertyListDecoder().decode(APIKey.self, from: data)
        else {
            Logger.log(event: .error, "Can't read API key file")
            return .zero
        }
        return result
    }
    
    lazy var urlHandler = URLHandler()

    // MARK: - Lifecycle
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let viewController = ScreenFactory().createAuthorizationScreen(apiKey: apiKey)

        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        urlHandler.handle(context.url)
    }
}

