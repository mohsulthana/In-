//
//  DashboardViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 12/08/22.
//

import UIKit

class DashboardViewController: UIViewController {
    let categoryItems = ["Order", "Completed", "Cancelled"]

    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: categoryItems)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray
        control.tintColor = .white
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    lazy var cancelledOrderTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(segmentedControl)

        setupConstraint()
    }

    fileprivate func setupConstraint() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
}
