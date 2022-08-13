//
//  ProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 05/08/22.
//

import UIKit
import CoreData

protocol ProductViewProtocol {
    func reloadData()
}

class ProductViewController: UIViewController {
    
    let item = ["Item 1", "Item 2"]
    var products: [Product] = []
    
    lazy var navBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: 66))
        let navItem = UINavigationItem(title: "Products")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(addItem))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        navBar.barTintColor = .white
        navBar.layer.borderColor = UIColor.white.cgColor
        navBar.layer.borderWidth = 0
        return navBar
    }()
    
    lazy var inventoryTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(navBar)
        
        fetchProduct()

        setupTableView()
    }
    
    private func fetchProduct() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        CoreDataManager.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.products = result
                self.inventoryTableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    @objc private func addItem() {
        let productDetailVC = NewProductViewController()
        productDetailVC.delegate = self
        productDetailVC.title = "Add New Product"
        productDetailVC.navigationController?.navigationBar.prefersLargeTitles = false
        present(productDetailVC, animated: true, completion: nil)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(inventoryTableView)
        
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            inventoryTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            inventoryTableView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            inventoryTableView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            inventoryTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InventoryTableViewCell else { return UITableViewCell() }
        cell.displayValue.text = products[indexPath.row].name
        cell.quantityValue.text = "Quantity: \(products[indexPath.row].quantity)"
        cell.brandValue.text = products[indexPath.row].brand
        cell.typeValue.text = products[indexPath.row].type
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = AddCustomerViewController()
        productDetailVC.productName = item[indexPath.row]
        present(productDetailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            print("delete")
        default:
            break
        }
    }
}

extension ProductViewController: ProductViewProtocol {
    func reloadData() {
        fetchProduct()
    }
}
