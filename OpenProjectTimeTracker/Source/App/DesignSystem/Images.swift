//
//  Images.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 12.10.22.
//

import UIKit

final class Images {
    static var iconMore: UIImage? { imageNamed("icon_more") }
    
    private static func imageNamed(_ name: String) -> UIImage? {
        let image = UIImage(named: name)
        if image == nil {
            Logger.log(event: .warning, "Can't load image \"\(name)\"")
        }
        return image
    }
}
