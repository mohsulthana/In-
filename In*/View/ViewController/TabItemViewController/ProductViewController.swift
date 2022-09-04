//
//  ProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 05/08/22.
//

import CoreData
import UIKit
import UserNotifications

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
    
    var products = [Product]() {
        didSet {
            products.sort { $0.name ?? "" < $1.name ?? "" }
        }
    }
    var searchResult: [Product] = []
    var searchController: UISearchController?
    let notif = NotificationManager()

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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addItem))
        navigationItem.rightBarButtonItem?.tintColor = .primary
        title = "Product"
        fetchProduct()
        setupTableView()
        
        notif.userNotificationCenter?.delegate = self
        notif.requestNotificationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProduct()
    }

    private func fetchProduct() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false

        CoreDataManager.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.products = result
                
                DispatchQueue.main.async {
                    self.inventoryTableView.reloadData()
                    
                    let zeroQuantity = self.products.filter { $0.quantity == 0 }
                    
                    if !zeroQuantity.isEmpty {
                        let product = zeroQuantity.first?.name
                        self.notif.sendNotification(product: product)
                    }
                }
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
            inventoryTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count == 0 {
            tableView.setEmptyMessage("Your product is empty. Add more by tap the plus button at the top.")
        } else {
            tableView.restore()
        }
        
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
        let price = searchResult.count > 0 ? searchResult[indexPath.row].price : products[indexPath.row].price
        
        cell.displayValue.text = productName
        cell.quantityValue.text = quantity == 0 ? "\(quantity) pcs. (Out of stock)" : "\(quantity) pcs"
        cell.brandValue.text = "Brand \(String(describing: brand ?? ""))"
        cell.typeValue.text = "Type \(String(describing: type ?? ""))"
        cell.priceValue.text = "$\(price)"
        
        cell.displayValue.textColor = .primary
        cell.quantityValue.textColor =  quantity == 0 ? .systemRed : .secondaryLabel
        cell.brandValue.textColor = .label
        cell.typeValue.textColor = .tertiaryLabel
        cell.priceValue.textColor = .label
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = searchController?.isActive ?? true ? searchResult : products
        
        if product[indexPath.row].quantity == 0 {
            let alert = UIAlertController(title: "Product is empty", message: "Please update the quantity or make purchase of another product.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Understand", style: .default, handler: { action in
                self.dismiss(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let customerPurchase = PurchaseProductViewController()
        customerPurchase.product = products[indexPath.row]
        customerPurchase.delegate = self
        present(UINavigationController(rootViewController: customerPurchase), animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            let editProduct = EditProductViewController()
            editProduct.product = self.products[indexPath.row]
            editProduct.row = indexPath
            editProduct.vc = self
            self.present(UINavigationController(rootViewController: editProduct), animated: true, completion: nil)
            
            completionHandler(true)
        }

        editAction.backgroundColor = .systemBlue
        let swipeActions = UISwipeActionsConfiguration(actions: [editAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ProductViewController: ProductViewProtocol {
    func reloadData() {
        fetchProduct()
    }
}

extension ProductViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "out_of_stock":
            let productViewController = ProductViewController()
            self.present(UINavigationController(rootViewController: productViewController), animated: true, completion: nil)
        default:
            break
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("aha")
    }
}
