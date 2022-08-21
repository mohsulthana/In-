//
//  PrepaidBankSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 15/08/22.
//

import IGListKit
import IGListSwiftKit

protocol PrepaidBankProtocol {
    func prepaidSwitchValueChanged()
}

class PrepaidBankSectionController: ListSectionController {
    
    private var identifier: PrepaidBankIdentifier?
    var view: PrepaidBankProtocol?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let collectionContext = collectionContext
        return CGSize(width: collectionContext?.containerSize.width ?? 0, height: 76)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: PrepaidBankCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "PrepaidBankCollectionViewCell", bundle: nil, for: self, at: index)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? PrepaidBankIdentifier
    }
}

final class PrepaidBankIdentifier: ListDiffable {
    
    let placeholder: String
    
    init(placeholder: String) {
        self.placeholder = placeholder
    }
    func diffIdentifier() -> NSObjectProtocol {
        return placeholder as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? PrepaidBankIdentifier else { return false }
        return placeholder == object.placeholder
    }
}
