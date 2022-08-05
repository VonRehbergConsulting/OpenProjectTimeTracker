//
//  TimerPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerPresenterProtocol: AnyObject {
    
}

final class TimerPresenter: TimerPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TimerViewProtocol?
    var model: TimerModelProtocol?
    
}
