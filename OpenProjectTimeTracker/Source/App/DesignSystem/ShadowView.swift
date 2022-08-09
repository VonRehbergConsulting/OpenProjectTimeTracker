//
//  ShadowView.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 09.08.22.
//

import UIKit

class ShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat { 16 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.gray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 4
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
