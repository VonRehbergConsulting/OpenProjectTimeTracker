//
//  Parser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol ParserProtocol {
    associatedtype Model
    func parse(_ data: Data) -> Model?
}
