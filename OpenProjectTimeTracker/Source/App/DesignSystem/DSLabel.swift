//
//  DSLabel.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 19.08.22.
//

import UIKit

class DSLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        textColor = Colors.brand
    }
}
