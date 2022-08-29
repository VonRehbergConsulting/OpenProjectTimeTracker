//
//  TaskServiceTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class TaskServiceTests: XCTestCase {
    
    var service: TaskService!
    var requestService: RequestServiceMock!
    var factory: WorkPackagesRequestFactoryProtocol!
    
    override func setUp() {
        requestService = RequestServiceMock()
        factory = WorkPackagesRequestFactory()
        service = TaskService(service: requestService, requestFactory: factory)
    }
    
    override func tearDown() {
        factory = nil
        requestService = nil
        service = nil
    }
    
    // MARK: - task
    
    func testTaskFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Error?
        
        // Act
        service.task(id: 3) { response in
            switch response {
            case .failure(let error):
                result = error
            case .success(_):
                XCTFail()
            }
        }
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    func testTaskSuccess() {
        // Arrange
        requestService.sendStub = .success(Task(selfHref: "qwe", subject: "asd", projectHref: "zxc"))
        var result: Task?
        
        // Act
        service.task(id: 3) { response in
            switch response {
            case .failure(_):
                XCTFail()
            case .success(let value):
                result = value
            }
        }
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    // MARK: - list
    
    func testListFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Error?
        
        // Act
        service.list(userID: 3, page: 1) { response in
            switch response {
            case .failure(let error):
                result = error
            case .success(_):
                XCTFail()
            }
        }
        
        // Assert
        XCTAssertNotNil(result)
    }
    
    func testListSuccess() {
        // Arrange
        requestService.sendStub = .success([Task(selfHref: "qwe", subject: "asd", projectHref: "zxc"),
                                            Task(selfHref: "rty", subject: "fgh", projectHref: "vbn")])
        var result: [Task]?
        
        // Act
        service.list(userID: 3, page: 1) { response in
            switch response {
            case .failure(_):
                XCTFail()
            case .success(let value):
                result = value
            }
        }
        
        // Assert
        XCTAssertEqual(result?.count, 2)
    }
}
