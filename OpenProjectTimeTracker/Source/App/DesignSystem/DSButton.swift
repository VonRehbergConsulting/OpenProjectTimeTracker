//
//  DSButton.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

class DSButton: UIButton {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = Colors.brand
        layer.cornerRadius = 12
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
}
