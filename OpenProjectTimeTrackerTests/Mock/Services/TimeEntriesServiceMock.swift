//
//  TimeEntriesServiceMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import Foundation

final class TimeEntriesServiceMock: TimeEntriesServiceProtocol {
    
    var listStub: Result<[TimeEntryListModel], Error>?
    func list(userID: Int, page: Int, date: Date, _ completion: @escaping (Result<[TimeEntryListModel], Error>) -> Void) {
        guard let listStub = listStub else { return }
        completion(listStub)
    }
    
    var createStub: Bool?
    func create(userID: Int, projectHref: String, workPackageHref: String, duration: Date, date: Date, comment: String?, _ completion: @escaping ((Bool) -> Void)) {
        guard  let createStub = createStub else { return }
        completion(createStub)
    }
    
    var updateStub: Bool?
    func update(id: Int, duration: Date, comment: String?, _ completion: @escaping ((Bool) -> Void)) {
        guard let updateStub = updateStub else { return }
        completion(updateStub)
    }
}
