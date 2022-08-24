//
//  TextfieldCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit

class TextfieldCollectionViewCell: UICollectionViewCell {
    
    var view: TextSectionDelegate?
    var identifier: TextfieldIdentifier? {
        didSet {
            setupTextfield()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupTextfield()
    }

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextfield()
    }
    
    private func setupTextfield() {
        textField.placeholder = identifier?.placeholder
        textField.text = identifier?.value
        textField.delegate = self
        textField.isUserInteractionEnabled = identifier?.isEnabled ?? true
        setupDoneToolbar()
    }
    
    fileprivate func setupDoneToolbar() {
        let textFieldToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped(_:)))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        textFieldToolbar.barStyle = .default
        textFieldToolbar.items = [flexibleButton, doneButton]
        textFieldToolbar.sizeToFit()
        textField.inputAccessoryView = textFieldToolbar
    }
    
    @objc func onDoneButtonTapped(_ sender: UIBarButtonItem) {
        view?.textfieldSectionTapped(identifier?.id ?? "", value: textField.text ?? "")
    }
}

extension TextfieldCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view?.textfieldSectionTapped(identifier?.id ?? "", value: textField.text ?? "")
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view?.textfieldSectionTapped(identifier?.id ?? "", value: textField.text ?? "")
    }
}
