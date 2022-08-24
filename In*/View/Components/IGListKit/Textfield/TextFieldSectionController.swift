//
//  TextFieldSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit
import IGListSwiftKit

@objc protocol TextSectionDelegate {
    func textfieldSectionTapped(_ id: String, value: String)
}

class TextFieldSectionController: ListSectionController {
    
    weak var identifier: TextfieldIdentifier?
    weak var view: TextSectionDelegate?
    
    convenience init(view: TextSectionDelegate?) {
        self.init()
        self.view = view
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 42)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: TextfieldCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "TextfieldCollectionViewCell", bundle: nil, for: self, at: index)
        cell.identifier = identifier
        cell.view = view
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? TextfieldIdentifier
    }
}

final class TextfieldIdentifier: ListDiffable {
    let id: String
    let placeholder: String
    var value: String?
    var isEnabled: Bool? = true
    
    init(_ id: String, placeholder: String, value: String? = nil, isEnabled: Bool? = true) {
        self.id = id
        self.placeholder = placeholder
        self.value = value
        self.isEnabled = isEnabled
    }
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? TextfieldIdentifier else { return false }
        return id == object.id && placeholder == object.placeholder && value == object.value && isEnabled == object.isEnabled
    }
}
