//
//  TimeEntriesDataProvider.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 16.08.22.
//

import Foundation

protocol TimeEntriesListDataProviderProtocol {
    var itemCount: Int { get }
    
    func item(at index: Int) -> TimeEntryListModel?
    
    func loadNext(_ completion: @escaping ([Int]) -> Void)
    func reload(_ completion: @escaping (() -> Void))
}

final class TimeEntriesDataProvider: TimeEntriesListDataProviderProtocol {
    
    typealias Item = TimeEntryListModel
    
    // MARK: - Properties
    
    private let userID: Int
    private let service: TimeEntriesServiceProtocol
    
    private var items = [TimeEntryListModel]()
    private var isLoading = false
    private var nextPage = 1
    
    private var preProcessHandler: (() -> Void)?
    private var clearCompletion: (() -> Void)?
    
    // MARK: -  Lifecycle
    
    init(userID: Int, service: TimeEntriesServiceProtocol) {
        self.userID = userID
        self.service = service
    }
    
    // MARK: - TimerModelProtocol
    
    var itemCount: Int {
        items.count
    }
    
    func item(at index: Int) -> TimeEntryListModel? {
        if index >= 0,
           index < items.count {
            return items[index]
        } else {
            return nil
        }
    }
    
    func loadNext(_ completion: @escaping ([Int]) -> Void) {
        guard isLoading == false else { return }
        isLoading = true
        Logger.log("Loading time entries")
        service.list(userID: userID, page: nextPage, date: Date()) { [weak self] result in
            guard let self = self else { return }
            if let preProcessHandler = self.preProcessHandler {
                self.preProcessHandler = nil
                preProcessHandler()
            }
            var indexes = [Int]()
            switch result {
            case .failure(let error):
                Logger.log(event: .failure, "Can't load time entries: \(error.localizedDescription)")
            case .success(let response):
                let responseCount = response.count
                Logger.log(event: .success, "Time entries loaded: \(responseCount)")
                if responseCount > 0 {
                    self.nextPage += 1
                    let firstIndex = self.items.count
                    self.items.append(contentsOf: response)
                    for i in firstIndex..<self.items.count  {
                        indexes.append(i)
                    }
                }
            }
            self.isLoading = false
            completion(indexes)
            if let clearCompletion = self.clearCompletion {
                self.reset(clearCompletion)
            }
        }
    }
    
    func reload(_ completion: @escaping (() -> Void)) {
        if isLoading {
            clearCompletion = completion
        }
        else {
            reset(completion)
        }
    }
    
    // MARK: - Private helpers
    
    private func reset(_ completion: @escaping (() -> Void)) {
        clearCompletion = nil
        preProcessHandler = { [weak self] in self?.items = [] }
        nextPage = 1
        loadNext { _ in completion() }
    }
}
