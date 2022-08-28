//
//  StepperCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit

class StepperCollectionViewCell: UICollectionViewCell {
    
    weak var view: TextSectionDelegate?
    var identifier: StepperIdentifier? {
        didSet {
            setupView()
        }
    }
    
    @IBOutlet weak var stepperValueTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupDoneToolbar() {
        let textFieldToolbar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped(_:)))
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        textFieldToolbar.barStyle = .default
        textFieldToolbar.items = [flexibleButton, doneButton]
        textFieldToolbar.sizeToFit()
        stepperValueTextField.delegate = self
        stepperValueTextField.inputAccessoryView = textFieldToolbar
    }
    
    @objc func onDoneButtonTapped(_ sender: UIBarButtonItem) {
        submitTextfieldValue()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValueTextField.text = Int(sender.value).description
        submitTextfieldValue()
    }
    
    private func setupView() {
        setupDoneToolbar()
        stepperLabel.text = identifier?.label
        stepper.maximumValue = Double(identifier?.maxValue ?? 10)
        stepper.value = Double(identifier?.value ?? 1)
        stepperValueTextField.text = Int(stepper.value).description
    }
    
    private func submitTextfieldValue() {
        stepperValueTextField.resignFirstResponder()
        view?.textfieldSectionTapped(identifier?.id ?? "", value: "\(Int(stepper.value))")
    }
}

extension StepperCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let value = Double(textField.text ?? "0"), value == 0 {
            stepper.value = 0
            stepperValueTextField.text = Int(stepper.value).description
        }
        
        if let value = Double(textField.text ?? "0"), value > stepper.maximumValue {
            stepper.value = Double(textField.text ?? "0") ?? 0
            stepperValueTextField.text = Int(stepper.value).description
        }
    }
}
