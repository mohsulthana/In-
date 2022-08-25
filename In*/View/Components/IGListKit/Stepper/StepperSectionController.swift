//
//  StepperSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit

class StepperSectionController: ListSectionController {
    
    weak var identifier: StepperIdentifier?
    weak var view: TextSectionDelegate?
    
    convenience init(view: TextSectionDelegate?) {
        self.init()
        self.view = view
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: StepperCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "StepperCollectionViewCell", bundle: nil, for: self, at: index)
        cell.view = view
        cell.identifier = identifier
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? StepperIdentifier
    }
}

final class StepperIdentifier: ListDiffable {
    
    let id: String
    let label: String
    let value: Int16?
    let maxValue: Int?
    
    init(_ id: String, label: String, maxValue: Int?, value: Int16? = 0) {
        self.id = id
        self.label = label
        self.maxValue = maxValue
        self.value = value
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? StepperIdentifier else { return false }
        return label == object.label &&
        id == object.id &&
        maxValue == object.maxValue &&
        value == object.value
    }
}
