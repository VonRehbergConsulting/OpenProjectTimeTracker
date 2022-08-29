//
//  ParsersTests.swift
//  OpenProjectTimeTrackerTests
//
//  Created by Denis Shtangey on 29.08.22.
//

@testable import OpenProjectTimeTracker
import XCTest

final class ParsersTests: XCTestCase {
    
    func testWorkPackageParser() {
        // Arrange
        let parser = WorkPackageParser()
        let message = """
            {
                "subject": "Send invitation to speakers",
                "_links": {
                    "self": {
                        "href": "/api/v3/work_packages/4",
                    },
                    "priority": {
                        "title": "Normal"
                    },
                    "project": {
                        "href": "/api/v3/projects/1",
                        "title": "Demo project"
                    },
                    "status": {
                        "title": "In progress"
                    }
                }
            }
        """
        let data = message.data(using: .utf8)!
        
        // Act
        let task = parser.parse(data)
        
        // Assert
        XCTAssertEqual(task?.subject, "Send invitation to speakers")
        XCTAssertEqual(task?.selfHref, "/api/v3/work_packages/4")
        XCTAssertEqual(task?.projectHref, "/api/v3/projects/1")
        XCTAssertEqual(task?.projectTitle, "Demo project")
        XCTAssertEqual(task?.prioriry, "Normal")
        XCTAssertEqual(task?.status, "In progress")
    }
    
    func testWorkPackagesParser() {
        // Arrange
        let parser = WorkPackagesParser()
        let message = """
            {
                "_embedded": {
                    "elements": [
                        {
                            "subject": "Subject 1",
                            "_links": {
                                "self": {
                                    "href": "/api/v3/work_packages/1",
                                },
                                "priority": {
                                    "title": "Normal"
                                },
                                "project": {
                                    "href": "/api/v3/projects/1",
                                    "title": "project 1"
                                },
                                "status": {
                                    "title": "In progress"
                                }
                            }
                        },
                        {
                            "subject": "Send invitation to speakers",
                            "_links": {
                                "self": {
                                    "href": "/api/v3/work_packages/2",
                                },
                                "priority": {
                                    "title": "High"
                                },
                                "project": {
                                    "href": "/api/v3/projects/2",
                                    "title": "project 2"
                                },
                                "status": {
                                    "title": "New"
                                }
                            }
                        }
                    ]
                }
            }
        """
        let data = message.data(using: .utf8)!
        
        // Act
        let result = parser.parse(data)
        
        // Assert
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?[0].subject, "Subject 1")
        XCTAssertEqual(result?[0].selfHref, "/api/v3/work_packages/1")
        XCTAssertEqual(result?[0].projectHref, "/api/v3/projects/1")
        XCTAssertEqual(result?[0].projectTitle, "project 1")
        XCTAssertEqual(result?[0].prioriry, "Normal")
        XCTAssertEqual(result?[0].status, "In progress")
    }
    
    func testUserDataParser() {
        // Arrange
        let parser = UserDataParser()
        let message = """
            {
                "id": 4
            }
        """
        let data = message.data(using: .utf8)!
        
        // Act
        let result = parser.parse(data)
        
        // Assert
        XCTAssertEqual(result, 4)
    }
    
    func testTimeEntriesListParser() {
        // Arrange
        let parser = TimeEntriesListParser()
        let message = """
            {
                "_embedded": {
                    "elements": [
                        {
                            "id": 1,
                            "hours": "PT5H20M34S",
                            "_links": {
                                "workPackage": {
                                    "href": "/api/v3/work_packages/1",
                                    "title": "task title"
                                },
                                "project": {
                                    "href": "/api/v3/projects/1",
                                    "title": "project 1"
                                }
                            },
                            "comment": {
                                "raw": "comment"
                            },
                        },
                        {
                            "id": 2,
                            "hours": "PT2H21M48S",
                            "_links": {
                                "workPackage": {
                                    "href": "/api/v3/work_packages/21",
                                    "title": "task title 2"
                                },
                                "project": {
                                    "title": "project 2"
                                }
                            },
                            "comment": {
                                "raw": "comment 23"
                            },
                        }
                    ]
                }
            }
        """
        let data = message.data(using: .utf8)!
        
        // Act
        let result = parser.parse(data)
        
        // Assert
        XCTAssertEqual(result?.count, 2)
        XCTAssertEqual(result?[1].id, 2)
        XCTAssertEqual(result?[1].workPackageID, 21)
        XCTAssertEqual(result?[1].workPackageTitle, "task title 2")
        XCTAssertEqual(result?[1].projectTitle, "project 2")
        XCTAssertEqual(result?[1].comment, "comment 23")
        XCTAssertEqual(result?[1].timeSpent.hour, 2)
        XCTAssertEqual(result?[1].timeSpent.minute, 21)
        XCTAssertEqual(result?[1].timeSpent.second, 48)
    }
}
