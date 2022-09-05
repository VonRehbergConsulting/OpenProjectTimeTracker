//
//  ConfigurableCell.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 05.08.22.
//

import UIKit

/// Object that conforms to this protocol must be configurable with defined configuration data.
public protocol ConfigurableCell: ReusableCell {

    associatedtype ConfigurationData

    /// Configure the cell with provided data.
    func configure(_ item: ConfigurationData, at indexPath: IndexPath)
}
