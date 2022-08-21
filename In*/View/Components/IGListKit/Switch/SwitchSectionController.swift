//
//  SwitchSectionController..swift
//  In*
//
//  Created by Mohammad Sulthan on 15/08/22.
//

import IGListKit
import IGListSwiftKit

protocol SwitchSectionControllerDelegate: AnyObject {
    func switchValueChanged(_ isOn: Bool)
}

class SwitchSectionController: ListSectionController {
    
    weak var delegate: SwitchSectionControllerDelegate?
    private var identifier: SwitchIdentifier?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 90)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: SwitchCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "SwitchCollectionViewCell", bundle: nil, for: self, at: index)
        cell.switchLabel.text = identifier?.label
        cell.delegate = self
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? SwitchIdentifier
    }
}

extension SwitchSectionController: SwitchDelegate {
    func valueChanged(value: Bool) {
        delegate?.switchValueChanged(value)
    }
}

final class SwitchIdentifier: ListDiffable {
    
    let label: String
    
    init(label: String) {
        self.label = label
    }
    func diffIdentifier() -> NSObjectProtocol {
        return label as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SwitchIdentifier else { return false }
        return label == object.label
    }
}
