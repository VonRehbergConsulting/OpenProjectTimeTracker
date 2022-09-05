//
//  TokenStorage.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 03.08.22.
//

import Foundation

protocol TokenStorageProtocol: AnyObject {
    var token: AuthorizationToken? { get set }
}

final class TokenStorage: TokenStorageProtocol {
    var token: AuthorizationToken? {
        set {
            save(newValue)
        }
        get {
            load()
        }
    }
    
    // MARK: - Private helpers
    
    private let service = "tokens"
    private let account = "openProject"
    
    func save(_ token: AuthorizationToken?) {
        
        let data = (try? JSONEncoder().encode(token)) ?? Data()
        
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        var status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem {
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: "tokens",
                kSecAttrAccount: "openProject"
            ] as CFDictionary
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            status = SecItemUpdate(query, attributesToUpdate)
        }
        
        
        if status != errSecSuccess {
            Logger.log(event: .error, "Error while saving to the keychain")
        }
    }
    
    func load() -> AuthorizationToken? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        guard let data = result as? Data,
              let token =  try? JSONDecoder().decode(AuthorizationToken.self, from: data)
        else {
            return nil
        }
        return token
    }
}
