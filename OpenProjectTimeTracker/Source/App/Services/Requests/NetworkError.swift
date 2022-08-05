//
//  NetworkError.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

enum NetworkError: Error {
    case parsingError
    
    var localizedDescription: String {
        switch self {
        case .parsingError:
            return "Unable to parse response data"
        }
    }
}
