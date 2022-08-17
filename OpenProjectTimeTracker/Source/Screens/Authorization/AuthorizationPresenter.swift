//
//  AuthorizationPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 17.08.22.
//

import Foundation

protocol AuthorizationPresenterProtocol: AnyObject {
    
    func getUserID(_ completion: @escaping (Int?) -> Void)
}

final class AuthorizationPresenter: AuthorizationPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: AuthorizationViewProrocol?
    var model: AuthorizationModelProtocol?
    
    // MARK: - AuthorizationPresenterProtocol
    
    func getUserID(_ completion: @escaping (Int?) -> Void) {
        model?.getUserID(completion)
    }
}
