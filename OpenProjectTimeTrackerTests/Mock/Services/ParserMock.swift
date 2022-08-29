//
//  ParserMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import Foundation

final class ParserMock: ParserProtocol {
    
    typealias Model = String
    
    var parserStub: String?
    func parse(_ data: Data) -> String? {
        return parserStub
    }
}
