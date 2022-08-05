//
//  TimerModel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerModelProtocol {
    
}

final class TimerModel: TimerModelProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TimerPresenterProtocol?
    
    private let userID: Int
    
    init(userID: Int) {
        self.userID = userID
    }
}
