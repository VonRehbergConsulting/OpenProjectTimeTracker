//
//  TimerScreenFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerScreenFactoryProtocol {
    
    func createTimerScreen(userID: Int) -> TimerViewController
    
}

final class TimerScreenFactory: TimerScreenFactoryProtocol {
    
    // MARK: - Properties
    
    private let service: RequestServiceProtocol
    
    // MARK: - Lifecycle
    
    init(service: RequestServiceProtocol) {
        self.service = service
    }
    
    // MARK: - TimerScreenFactoryProtocol
    
    func createTimerScreen(userID: Int) -> TimerViewController {
        let viewController = TimerViewController()
        let presenter = TimerPresenter()
        let model = TimerModel(userID: userID)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.model = model
        model.presenter = presenter
        
        return viewController
    }
}
