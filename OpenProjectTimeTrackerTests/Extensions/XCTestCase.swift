//
//  XCTestCase.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

import XCTest

extension XCTestCase {
    
    func assertSuccess<Success, Failure>(
        _ result: Result<Success, Failure>,
        message: String = "Expected to be a success but got a failure",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case .failure(_):
            XCTFail(message, file: file, line: line)
        case .success(_):
            break
        }
    }
    
    func assertFailure<Success, Failure>(
        _ result: Result<Success, Failure>,
        message: String = "Expected to be a success but got a failure",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case .success(_):
            XCTFail(message, file: file, line: line)
        case .failure(_):
            break
        }
    }
}
