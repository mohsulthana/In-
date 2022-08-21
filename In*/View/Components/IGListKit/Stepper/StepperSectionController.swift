//
//  StepperSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import IGListKit

class StepperSectionController: ListSectionController {
    
    private var identifier: StepperIdentifier?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: StepperCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "StepperCollectionViewCell", bundle: nil, for: self, at: index)
        cell.stepperLabel.text = identifier?.label
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? StepperIdentifier
    }
}

final class StepperIdentifier: ListDiffable {
    
    let label: String
    
    init(label: String) {
        self.label = label
    }
    func diffIdentifier() -> NSObjectProtocol {
        return label as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? StepperIdentifier else { return false }
        return label == object.label
    }
}
