//
//  LaunchPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

protocol LaunchPresenterProtocol: AnyObject {
    
    func checkAuthorization(_ completion: @escaping (LaunchModel.State) -> Void)
    
    func getUserID(_ completion: @escaping (Int?) -> Void)
}

final class LaunchPresenter: LaunchPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: LaunchViewProtocol?
    var model: LaunchModelProtocol?
    
    // MARK: - LaunchPresenterProtocol
    
    func checkAuthorization(_ completion: @escaping (LaunchModel.State) -> Void) {
        model?.checkAuthorization(completion)
    }
    
    func getUserID(_ completion: @escaping (Int?) -> Void) {
        model?.getUserID(completion)
    }
}
