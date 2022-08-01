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
}
