//
//  OrderDetailViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 24/08/22.
//

import CoreData
import IGListKit
import UIKit
import PDFKit

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
        
        if status == .completed {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(generatePDF(_:)))
        }
        
        if status == .pending {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(closeScreen(_:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closeScreen(_:)))
        }
        
        navigationItem.rightBarButtonItem?.tintColor = .primary

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    private func setupListdiffable() {
        var list: [ListDiffable] = []
        
        if let order = order {
            list.append(DataDetailIdentifier("product name", title: "Product Name", value: order.name ?? ""))
            list.append(DataDetailIdentifier("quantity", title: "Quantity", value: "\(String(describing: order.quantity )) pcs"))
            list.append(DataDetailIdentifier("customer", title: "Customer", value: "\(order.customer?.name ?? "Customer Name")"))
            list.append(DataDetailIdentifier("delivery method", title: "Delivery Method", value: order.delivery?.value ?? ""))
            list.append(DataDetailIdentifier("pickup method", title: "Pickup Method", value: order.pickup?.value ?? ""))

            list.append(DataDetailIdentifier("prepaid", title: "Prepaid", value: order.isPrepaid ? order.prepaid?.value ?? "" : "No Prepaid"))

            list.append(DataDetailIdentifier("notes", title: "Notes", value: order.notes?.isEmpty ?? true ? "No notes" : order.notes ?? ""))
            list.append(DataDetailIdentifier("status", title: "Status", value: status?.rawValue ?? ""))
            list.append(DataDetailIdentifier("total price", title: "Total Price", value: "$\(Int(order.totalPrice))" ))
            
            if status == .pending {
                list.append(ButtonIdentifier("complete pending order", title: "Complete"))
                list.append(ButtonIdentifier("cancel pending order", title: "Cancel", type: .secondary))
            }

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
    
    @objc func generatePDF(_ sender: UIBarButtonItem) {
        if let order = order {
            let pdfCreator = PDFCreator(title: "Completed Order", logo: UIImage(named: "logo") ?? UIImage(), date: Date(), invoice: order.invoice, name: order.name ?? "", brand: order.product?.brand ?? "", type: order.product?.type ?? "", quantity: order.quantity, price: order.totalPrice)
            let documentData = pdfCreator.createFlyer()
            let pdfViewerVC = PDFPreviewViewController()
            pdfViewerVC.order = order
            pdfViewerVC.documentData = documentData
            present(UINavigationController(rootViewController: pdfViewerVC), animated: true, completion: nil)
        }
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
                CoreDataManager.shared.completePendingOrder(item: order, product: order.product ?? Product())
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
