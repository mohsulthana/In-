//
//  DashboardViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 12/08/22.
//

import UIKit
import CoreData

enum StatusOrder: String {
    case pending, completed, cancelled
}

protocol RefreshDataProtocol {
    func reloadData()
}

class DashboardViewController: UIViewController {
    let categoryItems = ["Pending", "Completed", "Cancelled"]
    
    var pendingItems: [Order] = []
    var completedItems: [Order] = []
    var cancelledItems: [Order] = []
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: categoryItems)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.selectedSegmentTintColor = .primary
        control.tintColor = .primary
        control.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    lazy var cancelledOrderTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return table
    }()
    
    lazy var dashboardTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)
        title = "Order Reports"
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(generateReport))
        setupTableView()
        setupConstraint()
    }
    
    @objc func generateReport() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrder()
    }
    
    fileprivate func setupTableView() {
        view.addSubview(dashboardTableView)
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            dashboardTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            dashboardTableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            dashboardTableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            dashboardTableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func fetchOrder() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "status == %@", "pending")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        CoreDataManager.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.pendingItems = result
                self.dashboardTableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    private func fetchCompletedOrder() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "status == %@", "completed")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        CoreDataManager.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.completedItems = result
                self.dashboardTableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    private func fetchCancelledOrder() {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        let predicate = NSPredicate(format: "status == %@", "cancelled")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        
        CoreDataManager.shared.persistentContainer.viewContext.perform {
            do {
                let result = try fetchRequest.execute()
                self.cancelledItems = result
                self.dashboardTableView.reloadData()
            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    @objc private func segmentedControlChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchOrder()
        case 1:
            fetchCompletedOrder()
        case 2:
            fetchCancelledOrder()
        default:
             break
        }
        
        dashboardTableView.reloadData()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if pendingItems.count == 0 {
                tableView.setEmptyMessage("Empty pending list. Go to product page and add some there")
            } else {
                tableView.restore()
            }
            rows = pendingItems.count
        case 1:
            if completedItems.count == 0 {
                tableView.setEmptyMessage("Empty completed list.")
            } else {
                tableView.restore()
            }
            rows = completedItems.count
        case 2:
            if cancelledItems.count == 0 {
                tableView.setEmptyMessage("Empty cancelled list.")
            } else {
                tableView.restore()
            }
            rows = cancelledItems.count
        default:
            break
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = pendingItems[indexPath.row].customer?.name ?? "No customer name"
            cell.textLabel?.textColor = .primary
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case 1:
            cell.textLabel?.text = completedItems[indexPath.row].customer?.name ?? "No customer name"
            cell.textLabel?.textColor = .primary
        case 2:
            cell.textLabel?.text = cancelledItems[indexPath.row].customer?.name ?? "No customer name"
            cell.textLabel?.textColor = .systemRed
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let completeAction = UIContextualAction(style: .normal, title: "Complete") { (_, _, completionHandler) in
                let alert = UIAlertController(title: "Mark as complete", message: "Do you want to mark this order as completed order? This action cannot be reversed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                    let pendingOrder = self.pendingItems[indexPath.row]
                    CoreDataManager.shared.completePendingOrder(item: pendingOrder)
                    self.fetchOrder()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            let cancelAction = UIContextualAction(style: .normal, title: "Cancel") { (_, _, completionHandler) in
                let alert = UIAlertController(title: "Cancel Order", message: "Are you sure to cancel this order? This action cannot be reversed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes, Cancel", style: .destructive, handler: { action in
                    let pendingOrder = self.pendingItems[indexPath.row]
                    CoreDataManager.shared.cancelPendingOrder(item: pendingOrder, product: pendingOrder.product ?? Product())
                    self.fetchOrder()
                }))
                alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { action in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            cancelAction.backgroundColor = .systemRed
            completeAction.backgroundColor = .systemGreen
            
            let swipeActions = UISwipeActionsConfiguration(actions: [cancelAction, completeAction])
            return swipeActions
        default:
            break
        }
        
        return UISwipeActionsConfiguration()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let orderDetail = OrderDetailViewController()
            orderDetail.title = "Pending Order"
            orderDetail.order = pendingItems[indexPath.row]
            orderDetail.delegate = self
            orderDetail.status = .pending
            present(UINavigationController(rootViewController: orderDetail), animated: true, completion: nil)
        case 1:
            let orderDetail = OrderDetailViewController()
            orderDetail.title = "Completed Order"
            orderDetail.order = completedItems[indexPath.row]
            orderDetail.delegate = self
            orderDetail.status = .completed
            present(UINavigationController(rootViewController: orderDetail), animated: true, completion: nil)
        case 2:
            let orderDetail = OrderDetailViewController()
            orderDetail.title = "Cancelled Order"
            orderDetail.order = cancelledItems[indexPath.row]
            orderDetail.delegate = self
            orderDetail.status = .cancelled
            present(UINavigationController(rootViewController: orderDetail), animated: true, completion: nil)
        default:
            break
        }
    }
}

extension DashboardViewController: RefreshDataProtocol {
    func reloadData() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            fetchOrder()
        case 1:
            fetchCompletedOrder()
        case 2:
            fetchCancelledOrder()
        default:
             break
        }
    }
}
