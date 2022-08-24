//
//  DataDetailSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 24/08/22.
//

import Foundation
import IGListKit

class DataDetailSectionController: ListSectionController {
    
    weak var identifier: DataDetailIdentifier?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 70)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: DataDetailCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "DataDetailCollectionViewCell", bundle: nil, for: self, at: index)
        cell.identifier = identifier
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? DataDetailIdentifier
    }
}

class DataDetailIdentifier: ListDiffable {
    var id: String
    var title: String
    var value: String
    
    init(_ id: String, title: String, value: String) {
        self.id = id
        self.title = title
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? DataDetailIdentifier else { return false }
        return title == object.title && value == object.value
    }
}
