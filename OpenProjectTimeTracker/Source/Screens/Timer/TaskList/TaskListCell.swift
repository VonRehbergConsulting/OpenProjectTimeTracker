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
        static let edgeInset: CGFloat = 12
        static let stackViewSpacing: CGFloat = 4
    }
    
    // MARK: - Subviews
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(horisontalStackView)
        
        return stackView
    }()
    
    private lazy var horisontalStackView: UIStackView = {
        let stackView = UIStackView().disableMask()
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(detailLabel)
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().disableMask()
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 14)
        label.layer.cornerRadius = 8
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    
    // MARK: - Configuration model
    
    struct Configuration {
        var title: String
        var subtitle: String
        var content: String
        var detail: String
    }
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(verticalStackView)
        verticalStackView.attachToSuperview(inset: Constants.edgeInset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigurableCell
    
    typealias ConfigurationData = Configuration
    
    func configure(_ item: Configuration, at indexPath: IndexPath) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        contentLabel.text = item.content
        detailLabel.text = item.detail
    }
}
