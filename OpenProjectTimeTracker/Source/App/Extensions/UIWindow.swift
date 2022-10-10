//
//  UIWindow.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 10.10.22.
//

import UIKit

extension UIWindow {
    
    #if DEBUG
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        guard let rootViewController else { return }
        if motion == .motionShake {
            let viewController = LogScreen()
            rootViewController.present(viewController, animated: true)
        }
    }
    #endif
}
