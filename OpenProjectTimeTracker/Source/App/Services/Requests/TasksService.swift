//
//  TasksService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation
import UIKit

protocol TasksServiceProtocol {
    
    func loadTasks(id: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void)
}

final class TasksService: TasksServiceProtocol {
    
    private let pageSize = 20
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - TasksServiceProtocol
    
    func loadTasks(id: Int, page: Int, _ completion: @escaping (Result<[Task], Error>) -> Void) {
        let url = OpenProjectEndpoints.tasks.reference
        let parameters: [String: Any] = [
            "filters": "[{\"assignee\":{\"operator\":\"=\",\"values\":[\"\(id)\"]}}]",
            "pageSize": pageSize,
            "offset": page
        ]
        service.request(url, method: .get, parameters: parameters) { result in
            switch result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let embedded = json["_embedded"] as? [String: Any],
                   let elements = embedded["elements"] as? [[String: Any]] {
                    var tasks = [Task]()
                    for element in elements {
                        if let id = element["id"] as? Int,
                           let subject = element["subject"] as? String {
                            tasks.append(Task(id: id, subject: subject))
                        }
                    }
                    completion(.success(tasks))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
