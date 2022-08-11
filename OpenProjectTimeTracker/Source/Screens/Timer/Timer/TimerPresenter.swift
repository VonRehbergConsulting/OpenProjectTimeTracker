//
//  TimerPresenter.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import Foundation

protocol TimerPresenterProtocol: AnyObject {
    
    var state: TimerState? { get }
    var task: Task? { get set }
    var timeSpent: DateComponents? { get }
    
    func reset()
    
    func startTimer()
    func pauseTimer()
    func resumeTimer()
    func stopTimer()
    
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
    
    var state: TimerState? { model?.state }
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
    
    func reset() {
        model?.state = .setUp
        model?.startTime = nil
        model?.stopTime = nil
    }
    
    func startTimer() {
        guard var model = model else {
            Logger.log(event: .error, "Can't find model")
            return
        }
        model.state = .active
        model.startTime = Date()
    }
    
    func pauseTimer() {
        guard var model = model else {
            Logger.log(event: .error, "Can't find model")
            return
        }
        model.state = .paused
        model.stopTime = Date()
    }
    
    func resumeTimer() {
        guard var model = model,
              let startTime = model.startTime,
              let stopTime = model.stopTime else {
            Logger.log(event: .error, "Can't find model data")
            return
        }
        model.state = .active
        let pauseInterval = Date() - stopTime
        model.startTime = startTime.addingTimeInterval(pauseInterval)
        model.stopTime = nil
    }
    
    func stopTimer() {
        guard var model = model,
              model.startTime != nil
        else {
            Logger.log(event: .error, "Can't find model data")
            return
        }
        model.state = .setUp
        if model.stopTime != nil {
            resumeTimer()
        }
        model.stopTime = Date()
    }
}
