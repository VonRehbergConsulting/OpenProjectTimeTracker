//
//  DSTextField.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 12.08.22.
//

import UIKit

class DSTextField: UIView, UITextFieldDelegate {
    
    // MARK: - Constants
    
    private struct Constants {
        static let labelInset: CGFloat = 8
        static let edgeInset: CGFloat = 8
        static let spacing: CGFloat = 8
    }
    
    // MARK: - Subviews
    
    private lazy var textField: UITextField = {
        let textField = UITextField().disableMask()
        textField.isEnabled = true
        textField.backgroundColor = .clear
        textField.rightView = imageView
        textField.delegate = self
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView().disableMask()
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
        imageView.addGestureRecognizer(recognizer)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel().disableMask()
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = .clear
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var underlineLayer: CALayer = {
        var underlineLayer = CALayer()
        underlineLayer.backgroundColor = Colors.lightGray.cgColor
        self.layer.addSublayer(underlineLayer)
        return underlineLayer
    }()
    
    // MARK: - Properties
    
    var isEnabled: Bool {
        get { textField.isEnabled }
        set { textField.isEnabled = newValue }
    }
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    var caption: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    var buttonImage: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            if newValue != nil {
                textField.rightViewMode = .unlessEditing
            } else {
                textField.rightViewMode = .never
            }
        }
    }
    
    var shouldReturnHandler: (() -> Bool)?
    var buttonHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
        
        addSubview(textField)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leftAnchor.constraint(equalTo: leftAnchor),
            textField.rightAnchor.constraint(equalTo: rightAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Constants.labelInset),
            descriptionLabel.leftAnchor.constraint(equalTo: textField.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: textField.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineLayer.frame = CGRect(x: 0,
                                      y: textField.frame.maxY + Constants.labelInset / 2,
                                      width: bounds.width,
                                      height: 1)
    }
    
    override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder() || textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldReturnHandler?() ?? false
    }
    
    // MARK: - Actions
    
    @objc private func buttonAction() {
        buttonHandler?()
    }
}
