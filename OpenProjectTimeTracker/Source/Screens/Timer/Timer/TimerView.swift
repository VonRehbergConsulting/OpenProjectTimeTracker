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
        return label
    }()
    
    // MARK: - Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = bounds.height / 2
        }
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
        backgroundColor = Colors.start
        
        addSubview(label)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
