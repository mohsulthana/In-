//
//  NewProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 12/08/22.
//

import UIKit

class NewProductViewController: UIViewController {
    
    var delegate: ProductViewProtocol?
    
    lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Product Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addDoneToolbar()
        return field
    }()
    
    lazy var quantityTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Quantity In pcs"
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addDoneToolbar()
        return field
    }()
    
    lazy var brandTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Brand"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addDoneToolbar()
        return field
    }()
    
    lazy var typeTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Type"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.addDoneToolbar()
        return field
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .disabled)
        button.tintColor = .white
        button.layer.cornerRadius = 4
        button.backgroundColor = .primary
        button.addTarget(self, action: #selector(saveProductData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Add New Product"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(closeScreen(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .primary

        setupTextField()
        setupButton()
        setupConstraint()
    }
    
    @objc func closeScreen(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    func setupTextField() {
        view.addSubview(nameTextField)
        view.addSubview(quantityTextField)
        view.addSubview(brandTextField)
        view.addSubview(typeTextField)
    }
    
    func setupButton() {
        view.addSubview(submitButton)
    }

    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            quantityTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            quantityTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            quantityTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            brandTextField.topAnchor.constraint(equalTo: quantityTextField.bottomAnchor, constant: 24),
            brandTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            brandTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            typeTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 24),
            typeTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            typeTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            submitButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            submitButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 33)
        ])
    }
    
    @objc func saveProductData() {
        let managedObjectContext = CoreDataManager.shared.persistentContainer.viewContext
        
        let productData = Product(context: managedObjectContext)
        
        productData.name = nameTextField.text ?? ""
        productData.quantity = Int16(quantityTextField.text ?? "0") ?? 0
        productData.brand = brandTextField.text ?? ""
        productData.type = typeTextField.text ?? ""
        productData.id = UUID()
        
        do {
            try managedObjectContext.save()
            delegate?.reloadData()
            dismiss(animated: true)
        } catch {
            print("Unable to save customer data, \(error)")
        }
    }
}
