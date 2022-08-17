//
//  AuthorizationPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 17.08.22.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
    
    func authorize(_ completion: @escaping (_ userID: Int?) -> Void)
}

final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: AuthorizationViewProrocol?
    var model: AuthorizationModelProtocol?
    
    // MARK: - AuthorizationPresenterProtocol
    
    func authorize(_ completion: @escaping (_ userID: Int?) -> Void) {
        guard let model = model else {
            completion(nil)
            return
        }
        model.authorize() { success in
            if success {
                model.getUserID() { userID in
                    completion(userID)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func getUserID(_ completion: @escaping (Int?) -> Void) {
        model?.getUserID(completion)
    }
}
