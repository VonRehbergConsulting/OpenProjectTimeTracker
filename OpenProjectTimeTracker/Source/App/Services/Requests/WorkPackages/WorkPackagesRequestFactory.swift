//
//  WorkPackagesRequestFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol WorkPackagesRequestFactoryProtocol {
    
    func createWorkPackageRequestConfig(id: Int) -> RequestConfig<WorkPackageParser>
    
    func createWorkPackagesRequestConfig(userID: Int, page: Int) -> RequestConfig<WorkPackagesParser>
    
}

final class WorkPackagesRequestFactory: WorkPackagesRequestFactoryProtocol {
    
    func createWorkPackageRequestConfig(id: Int) -> RequestConfig<WorkPackageParser> {
        let request = WorkPackageRequest(id: id)
        let parser = WorkPackageParser()
        return RequestConfig(request: request, parser: parser)
    }
    
    func createWorkPackagesRequestConfig(userID: Int, page: Int) -> RequestConfig<WorkPackagesParser> {
        let request = WorkPackagesRequest(userID: userID, page: page)
        let parser = WorkPackagesParser()
        return RequestConfig(request: request, parser: parser)
    }
}
