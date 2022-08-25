//
//  OrderDetailViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 24/08/22.
//

import CoreData
import IGListKit
import UIKit

class OrderDetailViewController: UIViewController, ListAdapterDataSource {
    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var status: StatusOrder?

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var listDiffable: [ListDiffable] = []
    let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    weak var order: Order?
    var delegate: RefreshDataProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupListdiffable()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(closeScreen(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .primary

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    private func setupListdiffable() {
        var list: [ListDiffable] = []

        list.append(DataDetailIdentifier("product name", title: "Product Name", value: order?.product?.name ?? ""))
        list.append(DataDetailIdentifier("quantity", title: "Quantity", value: "\(String(describing: order?.product?.quantity ?? 0)) pcs"))
        list.append(DataDetailIdentifier("method", title: "Delivery Method", value: order?.deliveryType == DeliveryMethod.delivery.rawValue ? "Delivery" : "Pickup"))

        if order?.deliveryType == DeliveryMethod.delivery.rawValue {
            list.append(DataDetailIdentifier("delivery 1", title: "Delivery Address 1", value: order?.delivery?.address1 ?? "Empty Address"))
            list.append(DataDetailIdentifier("delivery 2", title: "Delivery Address 2", value: order?.delivery?.address2 ?? "Empty Address"))
            list.append(DataDetailIdentifier("delivery 3", title: "Delivery Address 3", value: order?.delivery?.address3 ?? "Empty Address"))
        } else if order?.deliveryType == DeliveryMethod.pickup.rawValue {
            list.append(DataDetailIdentifier("pickup 1", title: "Pickup Address 1", value: order?.pickup?.pickup1 ?? ""))
            list.append(DataDetailIdentifier("pickup 2", title: "Pickup Address 2", value: order?.pickup?.pickup2 ?? ""))
            list.append(DataDetailIdentifier("pickup 3", title: "Pickup Address 3", value: order?.pickup?.pickup3 ?? ""))
        }
        list.append(DataDetailIdentifier("prepaid", title: "Prepaid", value: order?.isPrepaid ?? false ? "Yes" : "No"))

        if order?.isPrepaid ?? false {
            list.append(DataDetailIdentifier("bank 1", title: "Bank 1", value: order?.bank?.bank1 ?? ""))
            list.append(DataDetailIdentifier("bank 2", title: "Bank 2", value: order?.bank?.bank2 ?? ""))
        }

        list.append(DataDetailIdentifier("notes", title: "Notes", value: order?.notes?.isEmpty ?? true ? "No notes" : order?.notes ?? ""))
        list.append(DataDetailIdentifier("status", title: "Status", value: status?.rawValue ?? ""))

        
        if status == .pending {
            list.append(ButtonIdentifier("complete pending order", title: "Complete"))
            list.append(ButtonIdentifier("cancel pending order", title: "Cancel", type: .secondary))
        }

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
        case is DataDetailIdentifier:
            return DataDetailSectionController()
        case is ButtonIdentifier:
            let sectionController = ButtonSectionController()
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

    @objc func closeScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension OrderDetailViewController: ButtonSectionControllerDelegate {
    private func completeOrder() {
        let alert = UIAlertController(title: "Mark as complete", message: "Do you want to mark this order as completed order? This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            if let order = self.order {
                CoreDataManager.shared.completePendingOrder(item: order)
            }
            self.delegate?.reloadData()
            self.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    private func cancelOrder() {
        let alert = UIAlertController(title: "Cancel Order", message: "Are you sure to cancel this order? This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes, cancel", style: .destructive, handler: { _ in
            if let order = self.order {
                CoreDataManager.shared.cancelPendingOrder(item: order, product: order.product ?? Product())
            }
            self.delegate?.reloadData()
            self.dismiss(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    func buttonSectionTapped(_ id: String) {
        if id == "complete pending order" {
            completeOrder()
        } else if id == "cancel pending order" {
            cancelOrder()
        }
    }
}
