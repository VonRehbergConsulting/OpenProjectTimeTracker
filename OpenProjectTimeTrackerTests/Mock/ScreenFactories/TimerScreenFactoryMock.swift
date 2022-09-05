//
//  TimerScreenFactoryMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 31.08.22.
//

@testable import OpenProjectTimeTracker
import UIKit

final class TimerScreenFactoryMock: TimerScreenFactoryProtocol {
    
    lazy var timerScreen = TimerViewController()
    func createTimerScreen(userID: Int) -> TimerViewController {
        timerScreen
    }
    
    lazy var taskListScreen = TaskListViewController()
    func createTaskListScreen(userID: Int) -> TaskListViewController {
        taskListScreen
    }
    
    lazy var summaryScreen = SummaryViewController()
    func createSummaryScreen(timeEntryID: Int?, userID: Int, taskHref: String, projectHref: String, timeSpent: DateComponents, taskTitle: String?, projectTitle: String?, comment: String?) -> SummaryViewController {
        return summaryScreen
    }
}
