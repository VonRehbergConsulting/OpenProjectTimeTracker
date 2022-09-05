//
//  UIView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 30.07.22.
//

import UIKit

extension UIView {
    
    @discardableResult
    func disableMask() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func attachToSuperview(inset: CGFloat = 0) {
        guard let superview = superview else { return }
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: inset),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: inset),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -inset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset)
        ])
    }
}
