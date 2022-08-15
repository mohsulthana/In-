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

class ProductViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterProductForSearchText(searchText)
            inventoryTableView.reloadData()
        }
    }
    
    private func filterProductForSearchText(_ searchText: String) {
        searchResult = products.filter({ (product: Product) -> Bool in
            let productNameMatch = product.name?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return productNameMatch != nil
        })
    }
    
    var products: [Product] = []
    var searchResult: [Product] = []
    var searchController: UISearchController?
    
    lazy var inventoryTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        title = "Product List"
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
        present(UINavigationController(rootViewController: productDetailVC), animated: true, completion: nil)
    }
    
    fileprivate func setupTableView() {
        view.addSubview(inventoryTableView)
        
        searchController = UISearchController(searchResultsController: nil)
        inventoryTableView.tableHeaderView = searchController?.searchBar
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        
        searchController?.searchBar.placeholder = "Search product by name"
        searchController?.hidesNavigationBarDuringPresentation = true
        
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            inventoryTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            inventoryTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            inventoryTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            inventoryTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController?.isActive ?? true {
            return searchResult.count
        }
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InventoryTableViewCell else { return UITableViewCell() }
        let productName = searchResult.count > 0 ? searchResult[indexPath.row].name : products[indexPath.row].name
        let quantity = searchResult.count > 0 ? searchResult[indexPath.row].quantity : products[indexPath.row].quantity
        let brand = searchResult.count > 0 ? searchResult[indexPath.row].brand : products[indexPath.row].brand
        let type = searchResult.count > 0 ? searchResult[indexPath.row].type : products[indexPath.row].type
        
        cell.displayValue.text = productName
        cell.quantityValue.text = "\(quantity) pcs"
        cell.brandValue.text = brand
        cell.typeValue.text = type
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerPurchase = PurchaseProductViewController()
        customerPurchase.product = products[indexPath.row]
        customerPurchase.delegate = self
        present(UINavigationController(rootViewController: customerPurchase), animated: true, completion: nil)
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
