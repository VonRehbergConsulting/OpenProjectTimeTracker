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
        service.request(url, method: .get, parameters: parameters, headers: [:], body: nil) { result in
            switch result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let embedded = json["_embedded"] as? [String: Any],
                   let elements = embedded["elements"] as? [[String: Any]] {
                    var tasks = [Task]()
                    for element in elements {
                        if let subject = element["subject"] as? String,
                           let links = element["_links"] as? [String: Any],
                           let project = links["project"] as? [String: Any],
                           let projectHref = project["href"] as? String,
                           let self = links["project"] as? [String: Any],
                           let selfHref = self["href"] as? String {
                            let projectTitle = project["title"] as? String
                            var priorityTitle: String?
                            if let priority = links["priority"] as? [String: Any] {
                                priorityTitle = priority["title"] as? String
                            }
                            var statusTitle: String?
                            if let status = links["status"] as? [String: Any] {
                                statusTitle = status["title"] as? String
                            }
                            
                            let task = Task(
                                selfHref: selfHref,
                                subject: subject,
                                projectHref: projectHref,
                                projectTitle: projectTitle,
                                prioriry: priorityTitle,
                                status: statusTitle)
                            tasks.append(task)
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
