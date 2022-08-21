//
//  DashboardViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 12/08/22.
//

import UIKit
import CoreData

protocol RefreshDataProtocol {
    func reloadData()
}

class DashboardViewController: UIViewController {
    let categoryItems = ["Pending", "Completed", "Cancelled"]
    
    var pendingOrder: [Order] = []
    var completedItems: [Order] = []
    var cancelledItems: [Order] = []
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: categoryItems)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.tintColor = .white
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(generateReport))
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
                self.pendingOrder = result
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
            rows = pendingOrder.count
        case 1:
            rows = completedItems.count
        case 2:
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
            cell.textLabel?.text = pendingOrder[indexPath.row].name
            cell.textLabel?.textColor = .darkText
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        case 1:
            cell.textLabel?.text = completedItems[indexPath.row].name
            cell.textLabel?.textColor = .darkText
        case 2:
            cell.textLabel?.text = cancelledItems[indexPath.row].name
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
                    let pendingOrder = self.pendingOrder[indexPath.row]
                    CoreDataManager.shared.completePendingOrder(item: pendingOrder)
                    self.fetchOrder()
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            let cancelAction = UIContextualAction(style: .normal, title: "Cancel") { (_, _, completionHandler) in
                let alert = UIAlertController(title: "Cancel Order", message: "Are you sure to cancel this order? This action cannot be reversed.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes, Cancel", style: .destructive, handler: { action in
                    let pendingOrder = self.pendingOrder[indexPath.row]
                    CoreDataManager.shared.cancelPendingOrder(item: pendingOrder)
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
            let pendingOrderDetail = PendingOrderViewController()
            pendingOrderDetail.title = "Pending Order"
            pendingOrderDetail.order = pendingOrder[indexPath.row]
            pendingOrderDetail.delegate = self
            present(UINavigationController(rootViewController: pendingOrderDetail), animated: true, completion: nil)
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
