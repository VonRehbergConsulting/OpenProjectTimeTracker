//
//  TimerTaskCell.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

class TimerTaskCell: UITableViewCell, ConfigurableCell {
    
    // MARK: - Configuration model
    
    struct Configuration {
        var subject: String
    }
    
    typealias ConfigurationData = Configuration
    
    // MARK: - ConfigurableCell
    
    func configure(_ item: Configuration, at indexPath: IndexPath) {
        textLabel?.text = item.subject
    }
}
