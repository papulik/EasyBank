//
//  CustomDatePicker.swift
//  EasyBank
//
//  Created by Zuka Papuashvili on 19.07.24.
//

import UIKit

class CustomDatePicker: UIView {
    let datePicker = UIDatePicker()
    let textField: CustomTextField
    
    init(placeholder: String) {
        textField = CustomTextField(placeholder: placeholder)
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolbar.barTintColor = .systemBackground
        toolbar.tintColor = .systemBlue
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
    }
    
    @objc private func dateChanged() {
        textField.text = formatDate(datePicker.date)
    }
    
    @objc private func doneTapped() {
        textField.text = formatDate(datePicker.date)
        textField.resignFirstResponder()
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
