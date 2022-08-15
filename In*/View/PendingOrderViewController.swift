//
//  PendingOrderViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 14/08/22.
//

import UIKit

class PendingOrderViewController: UIViewController {
    
    var order: Order?
    var delegate: RefreshDataProtocol?

    func generateLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    lazy var productNameValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var quantityValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .systemRed
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Complete", for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(completeOrder), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLabel()
        setupButton()

        if let order = order {
            productNameValue.text = order.name
            quantityValue.text = "\(order.quantity) pcs"
        }
    }
    
    @objc func completeOrder() {
        let alert = UIAlertController(title: "Mark as complete", message: "Do you want to mark this order as completed order? This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            if let order = self.order {
                CoreDataManager.shared.completePendingOrder(item: order)
            }
            self.delegate?.reloadData()
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelOrder() {
        let alert = UIAlertController(title: "Cancel Order", message: "Are you sure to cancel this order? This action cannot be reversed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes, cancel", style: .destructive, handler: { action in
            if let order = self.order {
                CoreDataManager.shared.cancelPendingOrder(item: order)
            }
            self.delegate?.reloadData()
            self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupButton() {
        view.addSubview(cancelButton)
        view.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24),
            cancelButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            completeButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -8),
            completeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }

    fileprivate func setupLabel() {
        let productNameLabel = generateLabel()
        productNameLabel.text = "Product Name"

        let quantityLabel = generateLabel()
        quantityLabel.text = "Quantity"

        view.addSubview(productNameLabel)
        view.addSubview(quantityLabel)
        view.addSubview(productNameValue)
        view.addSubview(quantityValue)

        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 24),
            productNameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            productNameValue.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productNameValue.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            productNameValue.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            quantityLabel.topAnchor.constraint(equalTo: productNameValue.bottomAnchor, constant: 24),
            quantityLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            quantityLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            quantityValue.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 8),
            quantityValue.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            quantityValue.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
}
