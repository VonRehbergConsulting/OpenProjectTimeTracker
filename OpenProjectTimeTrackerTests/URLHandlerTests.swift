//
//  URLHandlerTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 02.09.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class URLHandlerTests: XCTestCase {
    
    var handler: URLHandler<OAuthSwiftMock>!
    
    override func setUp() {
        handler = URLHandler<OAuthSwiftMock>()
    }
    
    override func tearDown() {
        handler = nil
    }
    
    func testHandleAuthCallback() {
        // Arrangw
        let url = URL(string: "openprojecttimetracker://oauth-callback?code=qwe_rty")!
        
        // Act
        handler.handle(url)
        
        // Assert
        XCTAssertTrue(OAuthSwiftMock.handleCalled) 
    }
}
