//
//  TimeEntryCreateParser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

final class EmptyParser: ParserProtocol {
    typealias Model = Void
    
    func parse(_ data: Data) -> Void? {
        return ()
    }
}
