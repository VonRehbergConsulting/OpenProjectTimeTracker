//
//  OAuthSwift.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 02.09.22.
//

import OAuthSwift
import Foundation

protocol OAuthSwiftProtocol {
    static func handle(url: URL)
}

extension OAuthSwift: OAuthSwiftProtocol {}
