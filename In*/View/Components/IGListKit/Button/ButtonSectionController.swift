//
//  ButtonSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 22/08/22.
//

import IGListKit

protocol ButtonSectionControllerDelegate: AnyObject {
    func buttonSectionTapped(_ id: String)
}

class ButtonSectionController: ListSectionController {
    
    private var identifier: ButtonIdentifier?
    weak var delegate: ButtonSectionControllerDelegate?
    
    override init() {
        super.init()
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 42)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: ButtonCollectionViewCell = collectionContext.dequeueReusableCell(withNibName: "ButtonCollectionViewCell", bundle: nil, for: self, at: index)
        cell.identifier = identifier
        cell.delegate = self
        return cell
    }
    
    override func didUpdate(to object: Any) {
        identifier = object as? ButtonIdentifier
    }
}

extension ButtonSectionController: ButtonDelegate {
    func buttonTapped(_ id: String) {
        delegate?.buttonSectionTapped(id)
    }
}

class ButtonIdentifier: ListDiffable {
    var id: String
    var title: String
    var type: ButtonType? = .primary
    
    init(_ id: String, title: String, type: ButtonType? = .primary) {
        self.id = id
        self.title = title
        self.type = type
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ButtonIdentifier else { return false }
        return id == object.id && title == object.title
    }
}
