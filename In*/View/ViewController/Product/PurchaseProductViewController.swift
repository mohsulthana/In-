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
    var pickupMethod: String?
    var prepaidMethod: String?

    var isPrepaid: Bool = false

    var deliveryValue: String?
    var pickupValue: String?
    var prepaidValue: String?

    var notes: String?
    
    var customerName: String?

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
    
    private let deliveryOptionsDataSource = [
        UIMagicDropdownData(label: DeliveryMethod.knutsfor.rawValue, value: DeliveryMethod.knutsfor.rawValue),
        UIMagicDropdownData(label: DeliveryMethod.bearer.rawValue, value: DeliveryMethod.bearer.rawValue),
        UIMagicDropdownData(label: DeliveryMethod.zipmail.rawValue, value: DeliveryMethod.zipmail.rawValue),
        UIMagicDropdownData(label: DeliveryMethod.other.rawValue, value: DeliveryMethod.other.rawValue),
    ]
    
    private let pickupOptionsDataSource = [
        UIMagicDropdownData(label: PickupMethod.hwt.rawValue, value: PickupMethod.hwt.rawValue),
        UIMagicDropdownData(label: PickupMethod.spanishTown.rawValue, value: PickupMethod.spanishTown.rawValue),
        UIMagicDropdownData(label: PickupMethod.other.rawValue, value: PickupMethod.other.rawValue),
    ]
    
    private let prepaidOptionsDataSource = [
        UIMagicDropdownData(label: PrepaidMethod.ncb.rawValue, value: PrepaidMethod.ncb.rawValue),
        UIMagicDropdownData(label: PrepaidMethod.scotiaBank.rawValue, value: PrepaidMethod.scotiaBank.rawValue),
        UIMagicDropdownData(label: PrepaidMethod.other.rawValue, value: PrepaidMethod.other.rawValue),
    ]

    private func setupListdiffable() {
        var list: [ListDiffable] = []
        list.append(TextfieldIdentifier(TextfieldId.productName.rawValue, placeholder: "Product Name", value: product?.name, isEnabled: false))
        list.append(TextfieldIdentifier(TextfieldId.customerName.rawValue, placeholder: "Customer Name"))
        list.append(StepperIdentifier("quantity", label: "Quantity", maxValue: Int(product?.quantity ?? 10)))
        list.append(DropdownIdentifier("delivery dropdown", data: deliveryOptionsDataSource, height: 270))

        if deliveryMethod == DeliveryMethod.other.rawValue {
            list.append(TextfieldIdentifier(TextfieldId.deliveryMethod.rawValue, placeholder: "Other Delivery"))
        }
        
        list.append(DropdownIdentifier("pickup dropdown", data: pickupOptionsDataSource))
        
        if pickupMethod == PickupMethod.other.rawValue {
            list.append(TextfieldIdentifier(TextfieldId.pickupMethod.rawValue, placeholder: "Other Pickup"))
        }

        list.append(SwitchIdentifier(label: "Prepaid"))

        if isPrepaid {
            list.append(DropdownIdentifier("prepaid dropdown", data: prepaidOptionsDataSource))
        }
        
        if prepaidMethod == PrepaidMethod.other.rawValue {
            list.append(TextfieldIdentifier(TextfieldId.prepaidMethod.rawValue, placeholder: "Other Prepaid"))
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
    func dropdownValueChanged(_ id: String, _ item: String) {
        if id == "delivery dropdown" {
            deliveryMethod = item
        } else if id == "pickup dropdown" {
            pickupMethod = item
        } else if id == "prepaid dropdown" {
            prepaidMethod = item
        }
        performUpdates()
    }
}

extension PurchaseProductViewController: TextSectionDelegate {
    func textfieldSectionTapped(_ id: String, value: String) {
        if id == TextfieldId.deliveryMethod.rawValue {
            deliveryValue = value
        } else if id == TextfieldId.pickupMethod.rawValue {
            pickupValue = value
        } else if id == TextfieldId.prepaidMethod.rawValue {
            prepaidValue = value
        } else if id == TextfieldId.notes.rawValue {
            notes = value
        } else if id == TextfieldId.quantity.rawValue {
            quantity = Int(value)
        } else if id == TextfieldId.customerName.rawValue {
            customerName = value
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
            let quantity = managedObject.value(forKey: "quantity") as! Int16 - Int16(quantity ?? 1)
            managedObject.setValue(quantity, forKey: "quantity")
        } catch let error as NSError {
            print(error)
        }
    }

    private func insertPurchasedData() {
        // core data object
        let deliveryObject = Delivery(context: managedObjectContext)
        let pickupObject = Pickup(context: managedObjectContext)
        let prepaidObject = Prepaid(context: managedObjectContext)
        let customerObject = Customer(context: managedObjectContext)
        
        if deliveryMethod != DeliveryMethod.other.rawValue {
            deliveryValue = deliveryMethod
        }
        
        if pickupMethod != PickupMethod.other.rawValue {
            pickupValue = pickupMethod
        }
        
        if prepaidMethod != PrepaidMethod.other.rawValue {
            prepaidValue = prepaidMethod
        }
        
        customerObject.name = customerName
        pickupObject.value = pickupValue
        deliveryObject.value = deliveryValue
        prepaidObject.value = prepaidValue
        

        if isPrepaid {
            prepaidObject.value = prepaidValue
        }

        let orderObject = Order(context: managedObjectContext)

        orderObject.product = product
        orderObject.id = UUID().uuidString
        orderObject.name = product?.name
        orderObject.quantity = Int16(quantity ?? 1)
        orderObject.status = "pending"
        orderObject.delivery = deliveryObject
        orderObject.pickup = pickupObject
        orderObject.prepaid = prepaidObject
        orderObject.notes = notes
        orderObject.isPrepaid = isPrepaid
        orderObject.customer = customerObject
        orderObject.totalPrice = Double((quantity ?? 1) * Int(product?.price ?? 0))
        orderObject.invoice = Int16(random(digits: 8)) ?? 0
        orderObject.createdOn = Date()

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
    
    func random(digits:Int) -> String {
        var number = String()
        for _ in 1...digits {
           number += "\(Int.random(in: 1...9))"
        }
        return number
    }
}
