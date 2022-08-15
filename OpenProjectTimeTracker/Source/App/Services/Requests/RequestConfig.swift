//
//  RequestConfig.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

struct RequestConfig<Parser> where Parser: ParserProtocol {
    var request: RequestProtocol
    var parser: Parser
}
