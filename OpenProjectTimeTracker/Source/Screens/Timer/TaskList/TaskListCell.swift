//
//  TimerTaskCell.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

class TaskListCell: UITableViewCell, ConfigurableCell {
    
    // MARK: - Constants
    
    private struct Constants {
        static let edgeInset: CGFloat = 8
        static let stackViewSpacing: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.spacing = Constants.stackViewSpacing
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(secondLabel)
        stackView.addArrangedSubview(thirdLabel)
        stackView.addArrangedSubview(fourthLabel)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    let secondLabel = TaskListCell.defaultLabel
    let thirdLabel = TaskListCell.defaultLabel
    let fourthLabel = TaskListCell.defaultLabel
    
    private static var defaultLabel: UILabel {
        return UILabel().disableMask()
    }
    
    // MARK: - Configuration model
    
    struct Configuration {
        var title: String
        var secondLine: String
        var thirdLine: String
        var fourthLine: String
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(stackView)
        stackView.attachToSuperview(inset: Constants.edgeInset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigurableCell
    
    typealias ConfigurationData = Configuration
    
    func configure(_ item: Configuration, at indexPath: IndexPath) {
        titleLabel.text = item.title
        secondLabel.text = item.secondLine
        thirdLabel.text = item.thirdLine
        fourthLabel.text = item.fourthLine
    }
}
