//
//  DropdownCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit
import UIMagicDropDown

protocol DropdownDelegate: AnyObject {
    func triggerChanges(_ id: String, _ item: String)
    func dropdownExpanded(_ expanded: Bool)
}

class DropdownCollectionViewCell: UICollectionViewCell, UIMagicDropDownDelegate {
    weak var identifier: DropdownIdentifier? {
        didSet {
            setupView()
        }
    }
    weak var view: PurchaseProductViewController?
    weak var delegate: DropdownDelegate?
    var expanded: Bool?
    
    func dropDownSelected(_ item: UIMagicDropdownData, _ sender: UIMagicDropdown) {
        delegate?.dropdownExpanded(expanded!)
        delegate?.triggerChanges(identifier?.id ?? "", item.value as? String ?? "")
    }
    
    func dropdownExpanded(_ sender: UIMagicDropdown) {
        delegate?.dropdownExpanded(expanded!)
    }
    
    func dropdownCompressed(_ sender: UIMagicDropdown) {

    }
    

    @IBOutlet weak var dropdown: UIMagicDropdown!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        dropdown.items = identifier?.data
        dropdown.dropDownDelegate = self
        dropdown.hintMessage = "Select \(String(describing: identifier?.id.capitalized ?? ""))"
        dropdown.frame = contentView.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
