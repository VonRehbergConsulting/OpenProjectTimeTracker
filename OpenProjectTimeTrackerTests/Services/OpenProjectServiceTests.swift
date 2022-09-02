//
//  OpenProjectServiceTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import OAuthSwift
import XCTest

final class OpenProjectServiceTests: XCTestCase {
    
    var service: OpenProjectService!
    var oauth2swift: OAuth2SwiftMock!
    var tokenStorage: TokenStorageMock!
    
    override func setUp() {
        oauth2swift = OAuth2SwiftMock()
        tokenStorage = TokenStorageMock()
        service = OpenProjectService(tokenStorage: tokenStorage, oauth2swift: oauth2swift)
    }
    
    override func tearDown() {
        service = nil
        oauth2swift = nil
        tokenStorage = nil
    }
    
    // MARK: - authorize
    
    func testAuthorizeFailure() {
        // Arrange
        oauth2swift.authorizeStub = .failure(.serverError(message: "Server error"))
        var result: Result<AuthorizationToken, Error>?
        
        // Act
        service.authorize() { response in
            result = response
        }
        
        // Assert
        XCTAssertNil(tokenStorage.token)
        if let result = result {
            assertFailure(result)
        } else {
            XCTFail("Found nil")
        }
    }
    
    func testAuthorizeSuccess() {
        // Arrange
        let credentials = OAuthSwiftCredential(consumerKey: "key", consumerSecret: "secret")
        credentials.oauthToken = "oauthToken"
        credentials.oauthRefreshToken = "refreshToken"
        oauth2swift.authorizeStub = .success((credentials, nil, [:]))
        var result: Result<AuthorizationToken, Error>?
        
        // Act
        service.authorize() { response in
            result = response
        }
        
        // Assert
        if let result = result {
            assertSuccess(result)
        } else {
            XCTFail("Found nil")
        }
        XCTAssertEqual(credentials.oauthToken, tokenStorage.token?.oauthToken)
        XCTAssertEqual(credentials.oauthRefreshToken, tokenStorage.token?.refreshToken)
    }
    
    // MARK: - refresh
    
    func testRefreshError() {
        // Arrange
        let oldToken = AuthorizationToken(oauthToken: "oldOauth", refreshToken: "oldRefresh")
        tokenStorage.token = oldToken
        oauth2swift.reniewAccessTokenStub = .failure(.serverError(message: "Server error"))
        var result: Result<AuthorizationToken, Error>?
        
        // Act
        service.refresh(oldToken) { response in
            result = response
        }
        
        // Assert
        XCTAssertEqual(tokenStorage.token, oldToken)
        if let result = result {
            assertFailure(result)
        } else {
            XCTFail("Found nil")
        }
    }
    
    func testRefreshUnauthorized() {
        // Arrange
        let oldToken = AuthorizationToken(oauthToken: "oldOauth", refreshToken: "oldRefresh")
        tokenStorage.token = oldToken
        let error = NSError(domain: "domain", code: 400)
        oauth2swift.reniewAccessTokenStub = .failure(.accessDenied(error: error, request: URLRequest(url: URL(string: "url")!)))
        var result: Result<AuthorizationToken, Error>?
        
        // Act
        service.refresh(oldToken) { response in
            result = response
        }
        
        // Assert
        XCTAssertNil(tokenStorage.token)
        if let result = result {
            assertFailure(result)
        } else {
            XCTFail("Found nil")
        }
    }
    
    func testRefreshSuccess() {
        // Arrange
        let oldToken = AuthorizationToken(oauthToken: "oldOauth", refreshToken: "oldRefresh")
        tokenStorage.token = oldToken
        let credentials = OAuthSwiftCredential(consumerKey: "key", consumerSecret: "secret")
        credentials.oauthToken = "newOauth"
        credentials.oauthRefreshToken = "newRefresh"
        oauth2swift.reniewAccessTokenStub = .success((credentials, nil, [:]))
        var newToken: AuthorizationToken?
        
        // Act
        service.refresh(oldToken) { response in
            switch response {
            case .success(let token):
                newToken = token
            case .failure(_):
                XCTFail("Error")
            }
        }
        
        // Assert
        XCTAssertEqual(tokenStorage.token, newToken)
    }
    
    // MARK: - send
    
    func testSendSuccess() {
        // Arrange
        let parser = ParserMock()
        parser.parserStub = "parsed"
        let config = RequestConfig(request: RequestMock(), parser: parser)
        oauth2swift.startAuthorizedRequestStub = .success(.init(data: Data(), response: .init(), request: nil))
        var result: String?
        
        // Act
        service.send(requestConfig: config) { response in
            switch response {
            case .failure(_):
                XCTFail("Error")
            case .success(let parsedResponse):
                result = parsedResponse
            }
        }
        
        // Assert
        XCTAssertEqual(result, "parsed")
    }
    
    func testSendFailure() {
        // Arrange
        let config = RequestConfig(request: RequestMock(), parser: ParserMock())
        oauth2swift.startAuthorizedRequestStub = .failure(.serverError(message: "Server error"))
        
        // Act
        service.send(requestConfig: config) { response in
            switch response {
            case .failure(_):
                break
            case .success(_):
                XCTFail("Error")
            }
        }
    }
    
    func testSendAnauthorized() {
        // Arrange
        tokenStorage.token = AuthorizationToken(oauthToken: "oldOauth", refreshToken: "oldRefresh")
        let config = RequestConfig(request: RequestMock(), parser: ParserMock())
        let error = NSError(domain: "domain", code: 400)
        oauth2swift.startAuthorizedRequestStub = .failure(.accessDenied(error: error, request: URLRequest(url: URL(string: "url")!)))
        
        // Act
        service.send(requestConfig: config) { response in
            switch response {
            case .failure(_):
                break
            case .success(_):
                XCTFail("Error")
            }
        }
        
        // Assert
        XCTAssertNil(tokenStorage.token)
    }
    
    func testSendTokenRenewal() {
        // Arrange
        let oldToken = AuthorizationToken(oauthToken: "oldOauth", refreshToken: "oldRefresh")
        tokenStorage.token = oldToken
        let credentials = OAuthSwiftCredential(consumerKey: "a", consumerSecret: "s")
        credentials.oauthToken = "newOauth"
        credentials.oauthRefreshToken = "newRefresh"
        oauth2swift.onTokenRenewalStub = .success(credentials)
        
        let parser = ParserMock()
        parser.parserStub = "parsed"
        let config = RequestConfig(request: RequestMock(), parser: parser)
        
        // Act
        service.send(requestConfig: config) { _ in }
        
        // Assert
        XCTAssertEqual(tokenStorage.token?.oauthToken, "newOauth")
        XCTAssertEqual(tokenStorage.token?.refreshToken, "newRefresh")
    }
}
