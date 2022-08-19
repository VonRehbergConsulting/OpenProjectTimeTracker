//
//  DSButton.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

class DSButton: UIButton {
    
    // MARK: - Style
    
    enum Style {
        case normal
        case inactive
    }
    
    // MARK: Constants
    
    var heightConstant: CGFloat { 44 }
    var cornerRadiusConstant: CGFloat { 12 }
    
    // MARK: - Properties
    
    var style: Style = .normal {
        didSet {
            switch style {
            case .normal:
                backgroundColor = Colors.secondary
                setTitleColor(Colors.brand, for: .normal)
            case .inactive:
                backgroundColor = Colors.inactive
                setTitleColor(Colors.background, for: .normal)
            }
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
        backgroundColor = Colors.secondary
        setTitleColor(Colors.brand, for: .normal)
        layer.cornerRadius = cornerRadiusConstant
        clipsToBounds = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: heightConstant).isActive = true
    }
}
