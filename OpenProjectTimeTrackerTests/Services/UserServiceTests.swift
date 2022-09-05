//
//  UserServiceTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class UserServiceTests: XCTestCase {
    
    var service: UserService!
    var requestService: RequestServiceMock!
    var factory: UserDataRequestFactory!
    
    override func setUp() {
        requestService = RequestServiceMock()
        factory = UserDataRequestFactory()
        service = UserService(service: requestService, requestFactory: factory)
    }
    
    override func tearDown() {
        factory = nil
        requestService = nil
        service = nil
    }
    
    func testGetUserIDFailure() {
        // Arrange
        requestService.sendStub = .failure(NetworkError.unknownError)
        var result: Error?
        
        // Act
        service.getUserID() { response in
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
    
    func testGetUserIDSuccess() {
        // Arrange
        requestService.sendStub = .success(2)
        var result: Int?
        
        // Act
        service.getUserID { response in
            switch response {
            case .failure(_):
                XCTFail()
            case .success(let value):
                result = value
            }
        }
        
        // Assert
        XCTAssertEqual(result, 2)
    }
}
