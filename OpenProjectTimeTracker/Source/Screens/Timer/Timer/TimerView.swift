//
//  TimerView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.08.22.
//

import UIKit

final class TimerView: UIView {
    
    // MARK: - Subviews
    
    private lazy var label: UILabel = {
        let label = UILabel().disableMask()
        label.font = .monospacedDigitSystemFont(ofSize: 60, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let text = text else {
            return
        }
        let fontSize = UIFont.bestFittingFontSize(for: text, in: bounds, fontDescriptor: label.font.fontDescriptor)
        label.font = label.font.withSize(fontSize)
    }
}
