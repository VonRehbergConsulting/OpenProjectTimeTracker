//
//  TimeEntriesService.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

protocol TimeEntriesServiceProtocol {
    
    func list(userID: Int?, page: Int, date: Date?, workPackage: Int?, _ completion: @escaping (Result<[TimeEntryListModel], Error>) -> Void)
    
    func create(userID: Int,
                projectHref: String,
                workPackageHref: String,
                duration: DateComponents,
                date: Date,
                comment: String?,
                _ completion: @escaping ((Bool) -> Void))
    
    func update(id: Int,
                duration: DateComponents,
                comment: String?,
                _ completion: @escaping ((Bool) -> Void))
}

final class TimeEntriesService: TimeEntriesServiceProtocol {
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    private let requestFactory: TimeEntriesRequestFactoryProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol,
         requestFactory: TimeEntriesRequestFactoryProtocol
    ) {
        self.service = service
        self.requestFactory = requestFactory
    }
    
    // MARK: - TimeEntriesServiceProtocol
    
    func list(userID: Int?, page: Int, date: Date?, workPackage: Int?, _ completion: @escaping (Result<[TimeEntryListModel], Error>) -> Void) {
        let requestConfig = requestFactory.createTimeEntriesListRquestConfig(userID: userID, page: page, date: date, workPackage: workPackage)
        service.send(requestConfig: requestConfig, completion)
    }
    
    func create(userID: Int,
                projectHref: String,
                workPackageHref: String,
                duration: DateComponents,
                date: Date,
                comment: String?,
                _ completion: @escaping ((Bool) -> Void)) {
        Logger.log("Creating time entry")
        let requestConfig = requestFactory.createTimeEnrtiesCreateRequestConfig(userID: userID, projectHref: projectHref, workPackageHref: workPackageHref, duration: duration, date: date, comment: comment)
        service.send(requestConfig: requestConfig) { result in
            switch result {
            case .success(_):
                Logger.log(event: .success, "Time entry created")
                completion(true)
            case .failure(let error):
                let nserror = error as NSError
                Logger.log(event: .failure, "Time entry creation failed with code \(nserror.code): \(nserror.description)")
                completion(false)
            }
        }
    }
    
    func update(id: Int, duration: DateComponents, comment: String?, _ completion: @escaping ((Bool) -> Void)) {
        Logger.log("Updating time entry")
        let requestConfig = requestFactory.createTimeEntriesUpdateRequestConfig(id: id, duration: duration, comment: comment)
        service.send(requestConfig: requestConfig) { result in
            switch result {
            case .success(_):
                Logger.log(event: .success, "Time entry updated")
                completion(true)
            case .failure(let error):
                let nserror = error as NSError
                Logger.log(event: .failure, "Time entry update failed with code \(nserror.code): \(nserror.description)")
                completion(false)
            }
        }
    }
}
