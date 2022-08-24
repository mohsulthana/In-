//
//  Extension+ListAdapter.swift
//  In*
//
//  Created by Mohammad Sulthan on 21/08/22.
//

import UIKit
import IGListKit

extension ListAdapter: ListAdapterDataSource {
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        []
    }
    
    public func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is SwitchIdentifier:
            return SwitchSectionController()
        default:
            return EmptySectionController()
        }
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        nil
    }
}
