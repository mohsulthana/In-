//
//  DropdownSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit
import UIMagicDropDown

protocol DropdownSectionControllerDelegate: AnyObject {
    func dropdownValueChanged(_ id: String, _ item: String)
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
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: isExpanded ? CGFloat(identifier?.height ?? 230) : 70)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: DropdownCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "DropdownCollectionViewCell", bundle: nil, for: self, at: index)
        cell.delegate = self
        cell.view = view
        cell.identifier = identifier
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
    
    func triggerChanges(_ id: String, _ item: String) {
        delegate?.dropdownValueChanged(id, item)
    }
}

final class DropdownIdentifier: ListDiffable {
    
    let id: String
    let placeholder: String = "Haha"
    let height: Int?
    let data: [UIMagicDropdownData]
    
    init(_ id: String, data: [UIMagicDropdownData], height: Int? = 230) {
        self.id = id
        self.data = data
        self.height = height
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? DropdownIdentifier else { return false }
        return id == object.id &&
        placeholder == object.placeholder &&
        height == object.height
    }
}
