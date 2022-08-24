//
//  DropdownSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit
import SwiftyMenu
import UIMagicDropDown

protocol DropdownSectionControllerDelegate: AnyObject {
    func dropdownValueChanged(_ item: String)
}

class DropdownSectionController: ListSectionController {
    
    private var identifier: DropdownIdentifier?
    weak var view: PurchaseProductViewController?
    weak var delegate: DropdownSectionControllerDelegate?
    var isExpanded = false
    
    convenience init(view: PurchaseProductViewController?) {
        self.init()
        self.view = view
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let collectionContext = collectionContext
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: isExpanded ? 200 : 70)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: DropdownCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "DropdownCollectionViewCell", bundle: nil, for: self, at: index)
        cell.delegate = self
        cell.view = view
        cell.expanded = !isExpanded
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? DropdownIdentifier
    }
}

extension DropdownSectionController: DropdownDelegate {
    func dropdownExpanded(_ expanded: Bool) {
        self.isExpanded = expanded
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.6, options: []) {
            self.collectionContext.invalidateLayout(for: self)
        }
        self.isExpanded = !expanded
    }
    
    func triggerChanges(_ item: String) {
        delegate?.dropdownValueChanged(item)
    }
}

final class DropdownIdentifier: ListDiffable {
    
    let placeholder: String = "Haha"
    
    func diffIdentifier() -> NSObjectProtocol {
        return placeholder as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? DropdownIdentifier else { return false }
        return placeholder == object.placeholder
    }
}
