//
//  UserService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation
import OAuthSwift

protocol UserServiceProtocol {
    
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void))
    
}

final class UserService: UserServiceProtocol {
    
    // MARK: - Response model
    
    private struct UserDataResponse: Codable {
        var id: Int
    }
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - UserServiceProtocol
    
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void)) {
        service.request(OpenProjectEndpoints.userData.reference, method: .get, parameters: [:], headers: [:], body: nil) { result in
            switch result {
            case .success(let data):
                if let userDataResponse = try? JSONDecoder().decode(UserDataResponse.self, from: data) {
                    completion(.success(userDataResponse.id))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
//        let body = try? JSONEncoder().encode(TimeEntry())
//        let headers: [String: String] = [
//            "Content-Type": "application/json"
//        ]
//        service.request("http://localhost:8080/api/v3/time_entries", method: .post, parameters: [:], headers: headers, body: body) { result in
//            switch result {
//            case .success(let data):
//                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                    Logger.log(event: .error, json)
//                }
//            case .failure(let error):
//                break
//            }
//        }
    }
}
