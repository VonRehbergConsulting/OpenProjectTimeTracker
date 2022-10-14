//
//  CommentSuggestionViewCell.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 11.10.22.
//

import UIKit

final class CommentSuggestionViewCell: UITableViewCell, ConfigurableCell {
    
    // MARK: - ConfigurableCell
    
    typealias ConfigurationData = String
    
    func configure(_ item: String, at indexPath: IndexPath) {
        var content = defaultContentConfiguration()
        content.text = item
        contentConfiguration = content
    }
}
