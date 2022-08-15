//
//  PurchaseProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 06/08/22.
//

import UIKit
import CoreData
import SimpleCheckbox

class PurchaseProductViewController: UIViewController {
    
    var deliveryType: String?
    let pickerArray = ["Pick", "Delivery"]
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    var product: Product?
    var quantity = 0.0
    var delegate: ProductViewProtocol?
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Product Name"
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        field.textColor = .lightGray
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.maximumValue = Double(product?.quantity ?? 0)
        stepper.autorepeat = false
        stepper.addTarget(self, action: #selector(quantityValueChanged(sender:)), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    lazy var quantityTextField: UITextField = {
        let field = UITextField()
        field.text = "Quantity \(Int(quantityStepper.value)) pcs"
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = false
        field.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
//    lazy var quantityTextField: UITextField = {
//        let field = UITextField()
//        field.borderStyle = .roundedRect
//        field.placeholder = "Quantity"
//        field.keyboardType = .numberPad
//
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        doneToolbar.barStyle = .default
//        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
//
//        let items = [flexSpace, done]
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        field.inputAccessoryView = doneToolbar
//        field.translatesAutoresizingMaskIntoConstraints = false
//        return field
//    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Add", for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deliveryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Select Delivery Type", for: .normal)
        button.tintColor = .lightGray
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(openDelivery), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var deliveryOne: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Delivery One"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var deliveryTwo: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Delivery Two"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var deliveryThree: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Delivery Three"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var pickupOne: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Pickup Location One"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    lazy var pickupTwo: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Pickup Location Two"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var pickupThree: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Pickup Location Three"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var bankOne: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Bank One"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var bankTwo: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Bank Two"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var checkbox: Checkbox = {
       let checkbox = Checkbox()
        checkbox.borderStyle = .circle
        checkbox.checkmarkStyle = .circle
        checkbox.addTarget(self, action: #selector(checkboxValueChaned(sender:)), for: .valueChanged)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
    
    lazy var prepaidLabel: UILabel = {
        let label = UILabel()
        label.text = "Prepaid"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupButton()
        setupCheckbox()
        setupLabel()
        
        title = "Add New Purchase"
        nameTextField.text = product?.name
    }
    
    // MARK: OBJC BUTTON ACTION
    @objc private func openDelivery() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        view.addSubview(picker)
                
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.items = [flexibleButton, doneButton]
        view.addSubview(toolBar)
    }
    
    @objc func doneButtonAction() {
            
    }
    
    @objc private func saveData() {
        let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        
        if let product = product {
            let productObject = product.objectID
            
            do {
                let object = try managedObjectContext.existingObject(with: productObject)
                let quantityValue = object.value(forKey: "quantity")!
                object.setValue(quantityValue as! Int - (Int(quantityStepper.value)), forKey: "quantity")
            } catch {
                print(error)
            }
        }
        
        let purchasedData = Order(context: managedObjectContext)
        
        purchasedData.id = UUID().uuidString
        purchasedData.name = nameTextField.text ?? ""
        purchasedData.quantity = Int16(quantityStepper.value)
        purchasedData.deliveryType = deliveryType ?? "delivery"
        purchasedData.status = "pending"
        
        do {
            try managedObjectContext.save()
            dismiss(animated: true)
            delegate?.reloadData()
        } catch {
            print("Unable to save purchased data, \(error)")
        }
    }
    
    @objc private func onDoneButtonTapped() {
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    @objc private func checkboxValueChaned(sender: Checkbox) {
        
    }
    
    @objc private func quantityValueChanged(sender: UIStepper) {
        quantityTextField.text = "Quantity \(Int(quantityStepper.value)) pcs"
    }
    
    // MARK: SETUP COMPONENTS
    
    fileprivate func setupLabel() {
        view.addSubview(prepaidLabel)
        view.addSubview(quantityTextField)
        
        NSLayoutConstraint.activate([
            prepaidLabel.topAnchor.constraint(equalTo: deliveryButton.layoutMarginsGuide.bottomAnchor, constant: 26),
            prepaidLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 12),
            
            quantityTextField.topAnchor.constraint(equalTo: nameTextField.layoutMarginsGuide.bottomAnchor, constant: 24),
            quantityTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            quantityTextField.trailingAnchor.constraint(equalTo: quantityStepper.leadingAnchor, constant: -8),
        ])
    }
    
    fileprivate func setupCheckbox() {
        view.addSubview(checkbox)
        
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: deliveryButton.layoutMarginsGuide.bottomAnchor, constant: 24),
            checkbox.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            checkbox.widthAnchor.constraint(equalToConstant: 25),
            checkbox.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    fileprivate func setupTextField() {
        view.addSubview(nameTextField)
        view.addSubview(quantityStepper)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            quantityStepper.topAnchor.constraint(equalTo: nameTextField.layoutMarginsGuide.bottomAnchor, constant: 26),
            quantityStepper.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    fileprivate func setupButton() {
        view.addSubview(submitButton)
        view.addSubview(deliveryButton)
        
        NSLayoutConstraint.activate([
            deliveryButton.topAnchor.constraint(equalTo: quantityStepper.bottomAnchor, constant: 24),
            deliveryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            deliveryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            deliveryButton.heightAnchor.constraint(equalToConstant: 33),
            
            submitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            submitButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
    
    fileprivate func resetDeliveryType() {
        deliveryOne.removeFromSuperview()
        deliveryTwo.removeFromSuperview()
        deliveryThree.removeFromSuperview()
        pickupOne.removeFromSuperview()
        pickupTwo.removeFromSuperview()
        pickupThree.removeFromSuperview()
    }
    
    func setupDeliveryAddress() {
        view.addSubview(deliveryOne)
        view.addSubview(deliveryTwo)
        view.addSubview(deliveryThree)
        
        NSLayoutConstraint.activate([
            deliveryOne.topAnchor.constraint(equalTo: deliveryButton.bottomAnchor, constant: 24),
            deliveryOne.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            deliveryOne.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            deliveryTwo.topAnchor.constraint(equalTo: deliveryOne.bottomAnchor, constant: 24),
            deliveryTwo.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            deliveryTwo.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            deliveryThree.topAnchor.constraint(equalTo: deliveryTwo.bottomAnchor, constant: 24),
            deliveryThree.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            deliveryThree.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func setupPickupLocationAddress() {
        view.addSubview(pickupOne)
        view.addSubview(pickupTwo)
        view.addSubview(pickupThree)
        
        NSLayoutConstraint.activate([
            pickupOne.topAnchor.constraint(equalTo: deliveryButton.bottomAnchor, constant: 24),
            pickupOne.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pickupOne.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            pickupTwo.topAnchor.constraint(equalTo: pickupOne.bottomAnchor, constant: 24),
            pickupTwo.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pickupTwo.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            pickupThree.topAnchor.constraint(equalTo: pickupTwo.bottomAnchor, constant: 24),
            pickupThree.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pickupThree.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    fileprivate func setupDeliveryTypeForm() {
        self.resetDeliveryType()
        
        if deliveryType == "delivery" {
            setupDeliveryAddress()
        } else {
            setupPickupLocationAddress()
        }
    }
    
    fileprivate func setupErrorMessage() {}
}

extension PurchaseProductViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = pickerArray[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliveryType = pickerArray[row].lowercased()
        deliveryButton.isSelected = true
        deliveryButton.setTitle("Type: \(pickerArray[row])", for: .selected)
        setupDeliveryTypeForm()
    }
}
