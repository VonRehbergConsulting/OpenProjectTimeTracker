//
//  UserDataParser.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

final class UserDataParser: ParserProtocol {
    
    private struct UserDataResponse: Codable {
        var id: Int
    }
    
    typealias Model = Int
    
    func parse(_ data: Data) -> Int? {
        if let userDataResponse = try? JSONDecoder().decode(UserDataResponse.self, from: data) {
            return userDataResponse.id
        } else {
            return nil
        }
    }
}
