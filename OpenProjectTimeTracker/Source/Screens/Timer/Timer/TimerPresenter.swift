//
//  TimerPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerPresenterProtocol: AnyObject {
    
    var isActive: Bool? { get }
    var timeEntryID: Int? { get set }
    var task: Task? { get set }
    var timeSpent: DateComponents? { get }
    
    func startTimer()
    func stopTimer()
    func resetTimer()
    
}

final class TimerPresenter: TimerPresenterProtocol {
    
    // MARK: - Struct
    
    struct TaskData {
        var taskTitle: String
        var taskHref: String
        var projectTitle: String
        var projectHref: String
    }
    
    // MARK: - Properties
    
    weak var view: TimerViewProtocol?
    var model: TimerModelProtocol?
    
    // MARK: - TimerPresenterProtocol
    
    var isActive: Bool? {
        get { model?.isActive }
        set { model?.isActive = newValue }
    }
    var timeEntryID: Int? {
        get { model?.timeEntryID }
        set { model?.timeEntryID = newValue }
    }
    var task: Task? {
        get { model?.task }
        set { model?.task = newValue }
    }
    
    var timeSpent: DateComponents? {
        guard let model = model,
              let startTime = model.startTime
        else {
            Logger.log(event: .error, "Can't find model")
            return nil
        }
        var currentTime = Date()
        if let stopTime = model.stopTime {
            currentTime = stopTime
        }
        var components = Calendar.current.dateComponents([.hour, .minute, .second], from: startTime, to: currentTime)
        components.calendar = .current
        return components
    }
    
    func startTimer() {
        guard var model = model else {
            Logger.log(event: .error, "Can't find model")
            return
        }
        if model.stopTime != nil {
            resumeTimer()
        } else {
            if model.startTime == nil {
                model.startTime = Date()
            }
            isActive = true
        }
    }
    
    func stopTimer() {
        guard var model = model else {
            Logger.log(event: .error, "Can't find model")
            return
        }
        isActive = false
        if model.stopTime == nil {
            model.stopTime = Date()
        }
    }
    
    func resetTimer() {
        isActive = false
        model?.startTime = nil
        model?.stopTime = nil
    }
    
    // MARK: - Private helpers
    
    private func resumeTimer() {
        guard var model = model,
              let startTime = model.startTime,
              let stopTime = model.stopTime else {
            Logger.log(event: .error, "Can't find model data")
            return
        }
        let pauseInterval = Date() - stopTime
        model.startTime = startTime.addingTimeInterval(pauseInterval)
        model.stopTime = nil
        isActive = true
    }
}
