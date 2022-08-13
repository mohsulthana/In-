//
//  AddCustomerViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 06/08/22.
//

import UIKit
import CoreData

class AddCustomerViewController: UIViewController {
    
    var deliveryType = ""
    var productName = ""
    let pickerArray = ["Pick", "Delivery"]
    var picker = UIPickerView()
    var toolBar = UIToolbar()
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Product Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var quantityTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Quantity"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Add", for: .normal)
        button.tintColor = .darkGray
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var deliveryButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Select Delivery Type", for: .normal)
        button.tintColor = .darkGray
        button.layer.borderColor = UIColor.darkGray.cgColor
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTextField()
        setupButton()
        setupConstraint()
    }
    
    fileprivate func setupDeliveryTypeForm() {
        self.resetDeliveryType()
        
        if deliveryType == "delivery" {
            setupDeliveryAddress()
        } else {
            setupPickupLocationAddress()
        }
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
    
    fileprivate func resetDeliveryType() {
        deliveryOne.removeFromSuperview()
        deliveryTwo.removeFromSuperview()
        deliveryThree.removeFromSuperview()
        pickupOne.removeFromSuperview()
        pickupTwo.removeFromSuperview()
        pickupThree.removeFromSuperview()
    }
    
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
                
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 40))
        toolBar.barStyle = UIBarStyle.black
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        view.addSubview(toolBar)
    }
    
    @objc private func saveData() {
        let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        
        let customerData = CustomerData(context: managedObjectContext)
        
        customerData.name = "Name"
        customerData.quantity = 2
        customerData.deliveryType = "delivery"
        
        do {
            try managedObjectContext.save()
            
            dismiss(animated: true)
        } catch {
            print("Unable to save customer data, \(error)")
        }
    }
    
    @objc private func onDoneButtonTapped() {
        picker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    
    fileprivate func setupTextField() {
        view.addSubview(nameTextField)
        view.addSubview(quantityTextField)
    }
    
    fileprivate func setupButton() {
        view.addSubview(submitButton)
        view.addSubview(deliveryButton)
    }
    
    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            quantityTextField.topAnchor.constraint(equalTo: nameTextField.layoutMarginsGuide.bottomAnchor, constant: 24),
            quantityTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            quantityTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            deliveryButton.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 24),
            deliveryButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            deliveryButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            deliveryButton.heightAnchor.constraint(equalToConstant: 33),
            
            submitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            submitButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
}

extension AddCustomerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        deliveryButton.setTitle("Type: \(pickerArray[row])", for: .normal)
        setupDeliveryTypeForm()
    }
}
