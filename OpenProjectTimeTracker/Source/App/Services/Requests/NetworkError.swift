//
//  NetworkError.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

enum NetworkError: Error {
    case parsingError
    case noConnection
    case unanthorized
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .parsingError:
            return "Unable to parse response data"
        case .noConnection:
            return "No connection to the server"
        case .unanthorized:
            return "You are not authorized"
        case .unknownError:
            return "Unknown error"
        }
    }
}
