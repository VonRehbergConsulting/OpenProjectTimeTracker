//
//  TimerViewController.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

protocol TimerViewProtocol: AnyObject {
    
}

final class TimerViewController: UIViewController,
                                 TimerViewProtocol {
    
    // MARK: - Properties
    
    var contentView: TimerContentView? { view as? TimerContentView }
    
    var presenter: TimerPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = TimerContentView()
    }
    
}
