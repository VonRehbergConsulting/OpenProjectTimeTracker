//
//  InfiniteDataSource.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol InfiniteDataSourceProtocol {
    
    associatedtype Model: Codable
    
    var itemCount: Int { get }
    
    func item(at indexPath: IndexPath) -> Model?
    
    func loadNext(_ completion: @escaping ([Int]) -> Void)
    func reload(_ completion: @escaping (() -> Void))
}
