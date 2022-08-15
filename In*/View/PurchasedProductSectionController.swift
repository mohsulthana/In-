//
//  PurchasedProductSectionController.swift
//  In*
//
//  Created by Mohammad Sulthan on 15/08/22.
//

import IGListKit

final class PurchasedProductSectionController: ListSectionController {
    
    private var text: String?
    
    override init() {
        super.init()
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext.dequeueReusableCell(of: PurchasedCollectionViewCell.self, for: self, at: index) as! PurchasedCollectionViewCell
        cell.configure(with: text)
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext.containerSize.width, height: 200)
    }
    
    override func didSelectItem(at index: Int) {
        print("Selected : \(String(describing: text))")
    }
    
    override func didUpdate(to object: Any) {
        self.text = object as? String
    }
}
