//
//  AuthorizationPresenterTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class AuthorizationPresenterTests: XCTestCase {
    
    var presenter: AuthorizationPresenter!
    var model: AuthorizationModelMock!
    
    override func setUp() {
        model = AuthorizationModelMock()
        presenter = AuthorizationPresenter()
        presenter.model = model
    }
    
    override func tearDown() {
        presenter = nil
        model = nil
    }
    
    func testAuthorizeSuccess() {
        // Arrange
        model.authorizeStub = true
        model.getUserIDStub = 10
        var userID: Int?
        
        // Act
        presenter.authorize() { result in
            userID = result
        }
        
        // Assert
        XCTAssertEqual(userID, 10)
    }
    
    func testAuthorizeFailure() {
        // Arrange
        model.authorizeStub = false
        var userID: Int?
        
        // Act
        presenter.authorize() { result in
            userID = result
        }
        
        // Assert
        XCTAssertNil(userID)
    }
    
    func testAuthorizeSuccess_userIDFail() {
        // Arrange
        model.authorizeStub = true
        model.getUserIDStub = nil
        var userID: Int?
        
        // Act
        presenter.authorize() { result in
            userID = result
        }
        
        // Assert
        XCTAssertNil(userID)
    }
    
    func testNoModel() {
        // Arrange
        presenter.model = nil
        var userID: Int?
        
        // Act
        presenter.authorize() { result in
            userID = result
        }
        
        // Assert
        XCTAssertNil(userID)
    }
}
