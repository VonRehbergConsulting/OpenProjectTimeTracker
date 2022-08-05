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
    
    // MARK: - Error
    
    enum NetworkError: Error {
        case parsingError
        
        var localizedDescription: String {
            switch self {
            case .parsingError:
                return "Unable to parse response data"
            }
        }
    }
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - UserServiceProtocol
    
    func getUserID(_ completion: @escaping ((Result<Int, Error>) -> Void)) {
        service.request(OpenProjectEndpoints.userData.reference, method: .get) { result in
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
    }
}
