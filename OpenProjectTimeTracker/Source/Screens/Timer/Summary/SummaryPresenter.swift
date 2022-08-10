//
//  SummaryPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import Foundation

protocol SummaryPresenterProtocol: AnyObject {
    
    var taskTitle: String? { get }
    var projectTitle: String? { get }
    var timeSpent: String? { get }
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void)
}

final class SummaryPresenter: SummaryPresenterProtocol {
    
    // MARK: Properties
    
    weak var view: SummaryViewProtocol?
    var model: SummaryModelProtocol?
    
    // MARK: - TimerPresenterProtocol
    
    var taskTitle: String? { model?.taskTitle }
    var projectTitle: String? { model?.projectTitle }
    var timeSpent: String? {
        guard let time = model?.timeSpent else { return nil }
        return convertDuration(time)
    }
    
    func createTimeEntry(_ completion: @escaping (Bool) -> Void) {
        model?.createTimeEntry(completion)
    }
    
    // MARK: - Private helpers
    
    private func convertDuration(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
