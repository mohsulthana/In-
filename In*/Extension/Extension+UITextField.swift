//
//  Extension+UITextField.swift
//  In*
//
//  Created by Mohammad Sulthan on 13/08/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func rightIcon(icon: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(systemName: icon)
        self.rightView = imageView
        self.rightViewMode = .always
    }
    
    func addDoneToolbar() {
        let textFieldToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped(_:)))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        textFieldToolbar.barStyle = .default
        textFieldToolbar.items = [flexibleButton, doneButton]
        textFieldToolbar.sizeToFit()
        self.inputAccessoryView = textFieldToolbar
    }
    
    @objc func onDoneButtonTapped(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
    }
}
