//
//  TasksService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation
import UIKit

protocol TasksServiceProtocol {
    
    func task(id: Int, _ completion: @escaping (Result<Task, Error>) -> Void)
    
    func list(userID: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void)
}

final class TasksService: TasksServiceProtocol {
    
    private let pageSize = 20
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    private let requestFactory: WorkPackagesRequestFactoryProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol,
         requestFactory: WorkPackagesRequestFactoryProtocol) {
        self.service = service
        self.requestFactory = requestFactory
    }
    
    // MARK: - TasksServiceProtocol
    
    func task(id: Int, _ completion: @escaping (Result<Task, Error>) -> Void) {
        let requestConfig = requestFactory.createWorkPackageRequestConfig(id: id)
        service.send(requestConfig: requestConfig) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let task):
                completion(.success(task))
            }
        }
    }
    
    func list(userID: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void) {
        let requestConfig = requestFactory.createWorkPackagesRequestConfig(userID: userID, page: page)
        service.send(requestConfig: requestConfig, completion)
    }
}
