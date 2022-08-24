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
    }
    
    private func submitTextfieldValue() {
        stepperValueTextField.resignFirstResponder()
        view?.textfieldSectionTapped(identifier?.id ?? "", value: stepperValueTextField.text ?? "")
    }
}
