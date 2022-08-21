//
//  TextFieldSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit
import IGListSwiftKit

protocol TextFieldSectionControllerDelegate: AnyObject {
    func switchValueChanged(_ isOn: Bool)
}

class TextFieldSectionController: ListSectionController {
    
    weak var delegate: SwitchSectionControllerDelegate?
    private var identifier: TextfieldIdentifier?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 42)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: TextfieldCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "TextfieldCollectionViewCell", bundle: nil, for: self, at: index)
        cell.textField.placeholder = identifier?.placeholder
        cell.textField
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? TextfieldIdentifier
    }
}

final class TextfieldIdentifier: ListDiffable {
    
    let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
    }
    func diffIdentifier() -> NSObjectProtocol {
        return placeholder as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? TextfieldIdentifier else { return false }
        return placeholder == object.placeholder
    }
}
