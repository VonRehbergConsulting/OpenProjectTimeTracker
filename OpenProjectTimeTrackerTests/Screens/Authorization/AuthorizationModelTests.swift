//
//  AuthorizationModelTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class AuthorizationModelTests: XCTestCase {
    
    var authorizationModel: AuthorizationModel!
    var authorizationService: AuthorizationServiceMock!
    var userService: UserServiceMock!
    
    override func setUp() {
        authorizationService = AuthorizationServiceMock()
        userService = UserServiceMock()
        authorizationModel = AuthorizationModel(authorizationService: authorizationService, userService: userService)
    }
    
    override func tearDown() {
        authorizationModel = nil
        authorizationService = nil
        userService = nil
    }
    
    // MARK: - authorize
    
    func testAuthorizeSuccess() {
        // Arrange
        authorizationService.authorizeStub = .success(AuthorizationToken(oauthToken: "oauth", refreshToken: "refresh"))
        var success: Bool!
        
        // Act
        authorizationModel.authorize() { result in
            success = result
        }
        
        // Assert
        XCTAssertTrue(success)
    }
    
    func testAuthorizeFailure() {
        // Arrange
        authorizationService.authorizeStub = .failure(NetworkError.unknownError)
        var success: Bool!
        
        // Act
        authorizationModel.authorize() { result in
            success = result
        }
        
        // Assert
        XCTAssertFalse(success)
    }
    
    // MARK: - getUserID
    
    func testGetUserIDSuccess() {
        // Arrange
        userService.getUserIDStub = .success(8)
        var userID: Int!
        
        // Act
        authorizationModel.getUserID() { result in
            userID = result
        }
        
        // Assert
        XCTAssertEqual(userID, 8)
    }
    
    func testGetUserIDFailure() {
        // Arrange
        userService.getUserIDStub = .failure(NetworkError.unknownError)
        var userID: Int!
        
        // Act
        authorizationModel.getUserID() { result in
            userID = result
        }
        
        // Assert
        XCTAssertNil(userID)
    }
    
}
