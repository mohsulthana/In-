//
//  SwitchCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit

protocol SwitchDelegate: AnyObject {
    func valueChanged(value: Bool)
}

class SwitchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    weak var delegate: SwitchDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func valueChanged(_ sender: UISwitch) {
        delegate?.valueChanged(value: sender.isOn)
    }
}
