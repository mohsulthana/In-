//
//  DropdownCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit
import UIMagicDropDown

enum DeliveryMethod: String {
    case delivery = "delivery"
    case pickup = "pickup"
}

protocol DropdownDelegate: AnyObject {
    func triggerChanges(_ item: String)
}

class DropdownCollectionViewCell: UICollectionViewCell, UIMagicDropDownDelegate {
    weak var view: PurchaseProductViewController?
    weak var delegate: DropdownDelegate?
    
    func dropDownSelected(_ item: UIMagicDropdownData, _ sender: UIMagicDropdown) {
        delegate?.triggerChanges(item.value as? String ?? "")
    }
    
    func dropdownExpanded(_ sender: UIMagicDropdown) {
        view?.collectionView.bringSubviewToFront(sender)
    }
    
    func dropdownCompressed(_ sender: UIMagicDropdown) {
        
    }
    

    @IBOutlet weak var dropdown: UIMagicDropdown!
    
    private let dropdownOptionsDataSource = [
        UIMagicDropdownData(label: "Delivery", value: DeliveryMethod.delivery.rawValue),
        UIMagicDropdownData(label: "Pickup", value: DeliveryMethod.pickup.rawValue),
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropdown.items = dropdownOptionsDataSource
        dropdown.dropDownDelegate = self
    }
}
