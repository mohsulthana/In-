//
//  PurchasedProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 15/08/22.
//

import CoreData
import IGListKit
import UIKit
import UIMagicDropDown

enum TextfieldId: String {
    case productName
    case deliveryOne, deliveryTwo, deliveryThree
    case pickupOne, pickupTwo, pickupThree
    case bankOne, bankTwo
    case quantity
    case notes
}

final class PurchaseProductViewController: UIViewController, ListAdapterDataSource {
    let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext

    lazy var adapter: ListAdapter = {
        ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    var listDiffable: [ListDiffable] = []
    var product: Product?
    var delegate: ProductViewProtocol?

    // form value
    var quantity: Int?
    var deliveryMethod: String?

    var isPrepaid: Bool = false

    var delivery1: String?
    var delivery2: String?
    var delivery3: String?

    var pickup1: String?
    var pickup2: String?
    var pickup3: String?

    var bank1: String?
    var bank2: String?

    var notes: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add New Purchase"
        setupListdiffable()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(closeScreen(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .primary

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    @objc func closeScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    private func setupListdiffable() {
        var list: [ListDiffable] = []
        list.append(TextfieldIdentifier(TextfieldId.productName.rawValue, placeholder: "Product Name", value: product?.name, isEnabled: false))
        list.append(StepperIdentifier("quantity", label: "Quantity", maxValue: Int(product?.quantity ?? 10)))
        list.append(DropdownIdentifier())

        if deliveryMethod == DeliveryMethod.delivery.rawValue {
            list.append(TextfieldIdentifier(TextfieldId.deliveryOne.rawValue, placeholder: "Delivery 1"))
            list.append(TextfieldIdentifier(TextfieldId.deliveryTwo.rawValue, placeholder: "Delivery 2"))
            list.append(TextfieldIdentifier(TextfieldId.deliveryThree.rawValue, placeholder: "Delivery 3"))
        } else if deliveryMethod == DeliveryMethod.pickup.rawValue {
            list.append(TextfieldIdentifier(TextfieldId.pickupOne.rawValue, placeholder: "Pickup 1"))
            list.append(TextfieldIdentifier(TextfieldId.pickupTwo.rawValue, placeholder: "Pickup 2"))
            list.append(TextfieldIdentifier(TextfieldId.pickupThree.rawValue, placeholder: "Pickup 3"))
        }

        list.append(SwitchIdentifier(label: "Prepaid"))

        if isPrepaid {
            list.append(TextfieldIdentifier(TextfieldId.bankOne.rawValue, placeholder: "Bank 1"))
            list.append(TextfieldIdentifier(TextfieldId.bankTwo.rawValue, placeholder: "Bank 2"))
        }

        list.append(TextfieldIdentifier(TextfieldId.notes.rawValue, placeholder: "Notes"))
        list.append(ButtonIdentifier("add purchase", title: "Add Purchase"))

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
        case is ButtonIdentifier:
            let sectionController = ButtonSectionController()
            sectionController.delegate = self
            return sectionController
        case is DropdownIdentifier:
            let sectionController = DropdownSectionController()
            sectionController.delegate = self
            return sectionController
        case is StepperIdentifier:
            let sectionController = StepperSectionController()
            sectionController.view = self
            return sectionController
        case is TextfieldIdentifier:
            let sectionController = TextFieldSectionController()
            sectionController.view = self
            return sectionController
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

extension PurchaseProductViewController: TextSectionDelegate {
    func textfieldSectionTapped(_ id: String, value: String) {
        if id == TextfieldId.deliveryOne.rawValue {
            delivery1 = value
        } else if id == TextfieldId.deliveryTwo.rawValue {
            delivery2 = value
        } else if id == TextfieldId.deliveryThree.rawValue {
            delivery3 = value
        } else if id == TextfieldId.pickupOne.rawValue {
            pickup1 = value
        } else if id == TextfieldId.pickupTwo.rawValue {
            pickup2 = value
        } else if id == TextfieldId.pickupThree.rawValue {
            pickup3 = value
        } else if id == TextfieldId.bankOne.rawValue {
            bank1 = value
        } else if id == TextfieldId.bankTwo.rawValue {
            bank2 = value
        } else if id == TextfieldId.notes.rawValue {
            notes = value
        } else if id == TextfieldId.quantity.rawValue {
            quantity = Int(value)
        }
    }
}

extension PurchaseProductViewController: ButtonSectionControllerDelegate {
    private func updateProductQuantity() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.predicate = NSPredicate(format: "(name = %@)", product?.name ?? "")

        do {
            let result = try managedObjectContext.fetch(fetchRequest)
            let managedObject = result[0] as! NSManagedObject
            let quantity = managedObject.value(forKey: "quantity") as! Int16 - Int16(quantity ?? 0)
            managedObject.setValue(quantity, forKey: "quantity")
        } catch let error as NSError {
            print(error)
        }
    }

    private func insertPurchasedData() {
        // core data object
        let deliveryObject = DeliveryAddress(context: managedObjectContext)
        let pickupObject = PickupAddress(context: managedObjectContext)
        let bankObject = Bank(context: managedObjectContext)

        if deliveryMethod == DeliveryMethod.delivery.rawValue {
            deliveryObject.address1 = delivery1
            deliveryObject.address2 = delivery2
            deliveryObject.address3 = delivery3
        } else if deliveryMethod == DeliveryMethod.pickup.rawValue {
            pickupObject.pickup1 = pickup1
            pickupObject.pickup2 = pickup2
            pickupObject.pickup3 = pickup3
        }

        if isPrepaid {
            bankObject.bank1 = bank1
            bankObject.bank2 = bank2
        }

        let orderObject = Order(context: managedObjectContext)

        orderObject.product = product
        orderObject.id = UUID().uuidString
        orderObject.name = product?.name
        orderObject.quantity = Int16(quantity ?? 0)
        orderObject.deliveryType = deliveryMethod
        orderObject.status = "pending"
        orderObject.delivery = deliveryObject
        orderObject.pickup = pickupObject
        orderObject.bank = bankObject
        orderObject.notes = notes
        orderObject.isPrepaid = isPrepaid

        updateProductQuantity()

        do {
            try managedObjectContext.save()
            dismiss(animated: true)
            delegate?.reloadData()
        } catch {
            print("Unable to save purchased data, \(error)")
        }
    }

    func buttonSectionTapped(_ id: String) {
        insertPurchasedData()
    }
}
