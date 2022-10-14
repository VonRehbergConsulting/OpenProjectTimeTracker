//
//  TimeEntriesDataProviderMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker

final class TimeEntriesDataProviderMock: TimeEntriesListDataProviderProtocol {
    
    var itemCount: Int = 0
    var timeSpent: Double = 0.0
    
    var itemStub: TimeEntryListModel?
    func item(at index: Int) -> TimeEntryListModel? {
        return itemStub
    }
    
    var loadNextStub: [Int]?
    func loadNext(_ completion: @escaping ([Int]) -> Void) {
        guard let loadNextStub = loadNextStub else { return }
        completion(loadNextStub)
    }
    
    var reloadCalled = false
    func reload(_ completion: @escaping (() -> Void)) {
        reloadCalled = true
        completion()
    }
}
