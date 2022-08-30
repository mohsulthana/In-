//
//  EditProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 24/08/22.
//

import UIKit
import IGListKit
import CoreData

class EditProductViewController: UIViewController, ListAdapterDataSource {
    
    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var vc: ProductViewController?
    var row: IndexPath?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var listDiffable: [ListDiffable] = []
    let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
    weak var product: Product?
    var delegate: RefreshDataProtocol?
    
    var updatedProductName: String?
    var updatedBrand: String?
    var updatedQuantity: Int16?
    var updatedType: String?
    var updatedPrice: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupListdiffable()
        
        title = "Edit Product"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(updateProduct(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .primary

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    private func setupListdiffable() {
        var list: [ListDiffable] = []

        list.append(TextfieldIdentifier("product name", placeholder: "Product Name", value: product?.name, isEnabled: true))
        list.append(StepperIdentifier("quantity", label: "Quantity", maxValue: 10000000, value: product?.quantity ?? 0))
        list.append(TextfieldIdentifier("brand", placeholder: "Write your brand", value: product?.brand, isEnabled: true))
        list.append(TextfieldIdentifier("type", placeholder: "Write your type", value: product?.type, isEnabled: true))
        list.append(TextfieldIdentifier("price", placeholder: "Write your price", value: "\(String(describing: Int(product?.price ?? 0)))", isEnabled: true))
        
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
        case is StepperIdentifier:
            let sectionController = StepperSectionController()
            sectionController.view = self
            return sectionController
        case is TextfieldIdentifier:
            let sectionController = TextFieldSectionController()
            sectionController.view = self
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

    @objc func updateProduct(_ sender: UIBarButtonItem) {
        
        let name = updatedProductName ?? product?.name
        let quantity = updatedQuantity ?? product?.quantity
        let brand = updatedBrand ?? product?.brand
        let type = updatedType ?? product?.type
        let price = updatedPrice ?? product?.price
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "(name = %@)", product?.name ?? "")

        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            let managedObject = result[0] as! NSManagedObject
            managedObject.setValue(name, forKey: "name")
            managedObject.setValue(quantity, forKey: "quantity")
            managedObject.setValue(brand, forKey: "brand")
            managedObject.setValue(type, forKey: "type")
            managedObject.setValue(price, forKey: "price")
            
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
        
        dismiss(animated: true)
        vc?.inventoryTableView.reloadRows(at: [row!], with: .automatic)
    }
}

extension EditProductViewController: TextSectionDelegate {
    func textfieldSectionTapped(_ id: String, value: String) {
        if id == "product name" {
            updatedProductName = value
        } else if id == "quantity" {
            updatedQuantity = Int16(value)
        } else if id == "brand" {
            updatedBrand = value
        } else if id == "type" {
            updatedType = value
        } else if id == "price" {
            updatedPrice = Double(value)
        }
    }
}

