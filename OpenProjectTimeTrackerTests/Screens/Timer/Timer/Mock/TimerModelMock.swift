//
//  TimerModelMock.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 22.08.22.
//

@testable import OpenProjectTimeTracker
import Foundation

final class TimerModelMock: TimerModelProtocol {
    var task: Task?
    var isActive: Bool = false
    var timeEntryID: Int?
    var comment: String?
    var startTime: Date?
    var stopTime: Date?
}
