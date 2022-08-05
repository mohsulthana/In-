//
//  ProductViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 05/08/22.
//

import UIKit

class ProductViewController: UIViewController {
    
    let item = ["Item 1", "Item 2"]
    
    lazy var navBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Inventory")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(selectorX))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
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
        
        setupTableView()
    }
    
    @objc private func selectorX() {
        print("aha")
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
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? InventoryTableViewCell else { return UITableViewCell() }
        cell.displayValue.text = item[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController()
        productDetailVC.productName = item[indexPath.row]
        present(productDetailVC, animated: true, completion: nil)
    }
}

