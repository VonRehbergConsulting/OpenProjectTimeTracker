//
//  TaskService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation
import UIKit

protocol TaskServiceProtocol {
    
    func task(id: Int, _ completion: @escaping (Result<Task, Error>) -> Void)
    
    func list(userID: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void)
}

final class TaskService: TaskServiceProtocol {
    
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
        service.send(requestConfig: requestConfig, completion)
    }
    
    func list(userID: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void) {
        let requestConfig = requestFactory.createWorkPackagesRequestConfig(userID: userID, page: page)
        service.send(requestConfig: requestConfig, completion)
    }
}
