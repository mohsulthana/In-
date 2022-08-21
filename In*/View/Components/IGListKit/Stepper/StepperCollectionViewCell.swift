//
//  StepperCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit

class StepperCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stepperValueTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        stepperValueTextField.text = "\(sender.value)"
    }
}
