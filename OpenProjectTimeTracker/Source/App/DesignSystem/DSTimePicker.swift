//
//  DSTimePicker.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 25.08.22.
//

import UIKit

class DSTimePicker: UIPickerView,
                    UIPickerViewDelegate,
                    UIPickerViewDataSource {
    
    // MARK: - Properties
    
    private let data = [
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
         31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    ]
    
    var hours: Int {
        data[0][selectedRow(inComponent: 0)]
    }
    var minutes: Int {
        data[1][selectedRow(inComponent: 1)]
    }
    
    var valueChangedCompletion: (() -> Void)?
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        delegate = self
        dataSource = self
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return data[0].count
        case 1:
            return data[1].count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[component][row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        valueChangedCompletion?()
    }
}
