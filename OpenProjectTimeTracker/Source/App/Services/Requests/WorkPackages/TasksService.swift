//
//  TasksService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation
import UIKit

protocol TasksServiceProtocol {
    
    func list(id: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void)
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
    
    func list(id: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void) {
        let requestConfig = requestFactory.createWorkPackagesRequestConfig(userID: id, page: page)
        service.send(requestConfig: requestConfig, completion)
    }
}
