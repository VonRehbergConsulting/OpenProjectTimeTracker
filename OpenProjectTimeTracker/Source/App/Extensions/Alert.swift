//
//  Alert.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 01.08.22.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String?, _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { _ in completion?() }))
        present(alert, animated: true)
    }
}
