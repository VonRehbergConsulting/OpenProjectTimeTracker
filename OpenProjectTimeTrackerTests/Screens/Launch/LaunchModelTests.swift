//
//  LaunchModelTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 17.08.22.
//

import XCTest
@testable import OpenProjectTimeTracker

final class LaunchModelTests: XCTestCase {
    
    var refreshTokenServiceMock: RefreshTokenServiceMock!
    var userServiceMock: UserServiceMock!
    var tokenStorageMock: TokenStorageMock!
    var launchModel: LaunchModel!
    
    override func setUp() {
        refreshTokenServiceMock = RefreshTokenServiceMock()
        userServiceMock = UserServiceMock()
        tokenStorageMock = TokenStorageMock()
        launchModel = LaunchModel(refreshService: refreshTokenServiceMock, userService: userServiceMock, tokenStorage: tokenStorageMock)
    }
    
    override func tearDown() {
        refreshTokenServiceMock = nil
        userServiceMock = nil
        tokenStorageMock = nil
        launchModel = nil
    }
    
    // MARK: - checkAuthorization

    func testCheckAuthorizationSuccess() {
        // Arrange
        let token = AuthorizationToken(oauthToken: "oauth", refreshToken: "refresh")
        tokenStorageMock.token = token
        refreshTokenServiceMock.refreshStub = .success(token)
        var state: LaunchModel.State?
        
        // Act
        launchModel.checkAuthorization() { result in
            state = result
        }
        
        // Assert
        XCTAssertEqual(state, .authorized)
    }
    
    func testCheckAuthorizationNoToken() {
        tokenStorageMock.token = nil
        var state: LaunchModel.State?
        
        // Act
        launchModel.checkAuthorization() { result in
            state = result
        }
        
        // Assert
        XCTAssertEqual(state, .unauthorized)
    }
    
    func testCheckAuthorizationNoConnection() {
        // Arrange
        let token = AuthorizationToken(oauthToken: "oauth", refreshToken: "refresh")
        tokenStorageMock.token = token
        refreshTokenServiceMock.refreshStub = .failure(NetworkError.unknownError)
        var state: LaunchModel.State?
        
        // Act
        launchModel.checkAuthorization() { result in
            state = result
        }
        
        // Assert
        XCTAssertEqual(state, .unableToAccess)
    }
    
    func testCheckAuthorizationUnauthorized() {
        // Arrange
        let token = AuthorizationToken(oauthToken: "oauth", refreshToken: "refresh")
        tokenStorageMock.token = token
        refreshTokenServiceMock.refreshStub = .failure(NetworkError.unanthorized)
        var state: LaunchModel.State?
        
        // Act
        launchModel.checkAuthorization() { result in
            state = result
        }
        
        // Assert
        XCTAssertEqual(state, .unauthorized)
    }
    
    // MARK: - checkAuthorization
    
    func testGetUserIDSuccess() {
        // Arrange
        userServiceMock.getUserIDStub = .success(123)
        var userID: Int?
        
        // Act
        launchModel.getUserID { result in
            userID = result
        }
        
        // Assert
        XCTAssertEqual(userID, 123)
    }
    
    func testGetUserIDFailure() {
        // Arrange
        userServiceMock.getUserIDStub = .failure(NetworkError.unknownError)
        var userID: Int?
        
        // Act
        launchModel.getUserID { result in
            userID = result
        }
        
        // Assert
        XCTAssertEqual(userID, nil)
    }
}
