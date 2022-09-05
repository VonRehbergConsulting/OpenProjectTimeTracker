//
//  Request.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol RequestProtocol {
    var url: String { get set }
    var method: HTTPMethod { get set }
    var parameters: [String: Any] { get set }
    var headers: [String: String] { get set }
    var body: Data? { get set }
}
