//
//  PlistReader.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 04.08.22.
//

import Foundation

protocol PlistReaderProtocol {
    associatedtype T: Codable
    func read(from FileName: String) -> T?
}

class PlistReader<T: Codable>: PlistReaderProtocol {
    
    func read(from fileName: String) -> T? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist")
        else {
            Logger.log(event: .error, "Can't find plist file")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url),
              let result = try? PropertyListDecoder().decode(T.self, from: data)
        else {
            Logger.log(event: .error, "Can't read plist file")
            return nil
        }
        return result
    }
}
