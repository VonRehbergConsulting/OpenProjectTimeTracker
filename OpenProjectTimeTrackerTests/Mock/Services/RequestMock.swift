//
//  RequestMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import Foundation

struct RequestMock: RequestProtocol {
    var url: String = ""
    var method: HTTPMethod = .get
    var parameters: [String : Any] = [:]
    var headers: [String : String] = [:]
    var body: Data?
}
