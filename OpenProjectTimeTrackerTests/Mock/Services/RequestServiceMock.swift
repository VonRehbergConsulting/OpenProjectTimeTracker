//
//  RequestServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker

final class RequestServiceMock: RequestServiceProtocol {
    
    var sendStub: Result<Any, Error>?
    func send<Parser>(requestConfig: RequestConfig<Parser>, _ completion: @escaping (Result<Parser.Model, Error>) -> Void) where Parser : ParserProtocol {
        guard let sendStub = sendStub else { return }
        switch sendStub {
        case .failure(let error):
            completion(.failure(error))
        case .success(let value):
            if let convertedValue = value as? Parser.Model {
                completion(.success(convertedValue))
            }
        }
    }
}
