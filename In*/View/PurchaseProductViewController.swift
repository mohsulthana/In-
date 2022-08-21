//
//  PurchasedProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 15/08/22.
//

import IGListKit
import UIKit
import UIMagicDropDown

final class PurchaseProductViewController: UIViewController, ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var listDiffable: [ListDiffable] = []
    var isPrepaid: Bool = false
    var deliveryMethod: String?
    var product: Product?
    var delegate: ProductViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Purchase"
        setupListdiffable()
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    private func setupListdiffable() {
        var list: [ListDiffable] = []
        list.append(TextfieldIdentifier(placeholder: "Product Name"))
        list.append(StepperIdentifier(label: "Quantity"))
        list.append(DropdownIdentifier())
        
        if deliveryMethod == DeliveryMethod.delivery.rawValue {
            list.append(TextfieldIdentifier(placeholder: "Delivery 1"))
            list.append(TextfieldIdentifier(placeholder: "Delivery 2"))
            list.append(TextfieldIdentifier(placeholder: "Delivery 3"))
        } else if deliveryMethod == DeliveryMethod.pickup.rawValue {
            list.append(TextfieldIdentifier(placeholder: "Pickup 1"))
            list.append(TextfieldIdentifier(placeholder: "Pickup 2"))
            list.append(TextfieldIdentifier(placeholder: "Pickup 3"))
        }
        
        list.append(SwitchIdentifier(label: "Prepaid"))
        
        if isPrepaid {
            list.append(PrepaidBankIdentifier(placeholder: "Hello"))
        }
        
        list.append(TextfieldIdentifier(placeholder: "Notes"))
        
        listDiffable = list
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return listDiffable
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case is DropdownIdentifier:
            let sectionController = DropdownSectionController()
            sectionController.delegate = self
            return sectionController
        case is StepperIdentifier:
            return StepperSectionController()
        case is TextfieldIdentifier:
            return TextFieldSectionController()
        case is PrepaidBankIdentifier:
            return PrepaidBankSectionController()
        case is SwitchIdentifier:
            let sectionController = SwitchSectionController()
            sectionController.delegate = self
            return sectionController
        default:
            return EmptySectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    private func performUpdates() {
        setupListdiffable()
        
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true)
        }
    }
}


extension PurchaseProductViewController: SwitchSectionControllerDelegate {
    func switchValueChanged(_ isOn: Bool) {
        isPrepaid = isOn
        performUpdates()
    }
}

extension PurchaseProductViewController: DropdownSectionControllerDelegate {
    func dropdownValueChanged(_ item: String) {
        deliveryMethod = item
        performUpdates()
    }
}
