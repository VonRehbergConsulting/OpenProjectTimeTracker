//
//  TimeEntriesRequestFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol TimeEntriesRequestFactoryProtocol {
    
    func createTimeEntriesListRquestConfig(userID: Int?, page: Int, date: Date?, workPackage: Int?) -> RequestConfig<TimeEntriesListParser>
    
    func createTimeEnrtiesCreateRequestConfig(userID: Int,
                                              projectHref: String,
                                              workPackageHref: String,
                                              duration: DateComponents,
                                              date: Date,
                                              comment: String?
    ) -> RequestConfig<EmptyParser>
    
    func createTimeEntriesUpdateRequestConfig(id: Int, duration: DateComponents, comment: String?) -> RequestConfig<EmptyParser>
}

final class TimeEntriesRequestFactory: TimeEntriesRequestFactoryProtocol {
    
    func createTimeEntriesListRquestConfig(userID: Int?, page: Int, date: Date?, workPackage: Int?)  -> RequestConfig<TimeEntriesListParser> {
        let request = TimeEntriesListRequest(userID: userID, page: page, date: date, workPackage: workPackage)
        let parser = TimeEntriesListParser()
        return RequestConfig(request: request, parser: parser)
    }
    
    func createTimeEnrtiesCreateRequestConfig(
        userID: Int,
        projectHref: String,
        workPackageHref: String,
        duration: DateComponents,
        date: Date,
        comment: String?
    ) -> RequestConfig<EmptyParser> {
        let request = TimeEntriesCreateRequest(userID: userID, projectHref: projectHref, workPackageHref: workPackageHref, duration: duration, date: date, comment: comment)
        let parser = EmptyParser()
        return RequestConfig(request: request, parser: parser)
    }
    
    func createTimeEntriesUpdateRequestConfig(id: Int, duration: DateComponents, comment: String?) -> RequestConfig<EmptyParser> {
        let request = TimeEntryUpdateRequest(id: id, duration: duration, comment: comment)
        let parser = EmptyParser()
        return RequestConfig(request: request, parser: parser)
    }
}
