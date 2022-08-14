//
//  ProductDetailViewController.swift
//  In*
//
//  Created by Mohammad Sulthan on 06/08/22.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var productName = ""
    
    lazy var navBar: UINavigationBar = {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Product Detail")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(selectorX))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = productName
        view.backgroundColor = .white
        view.addSubview(navBar)
    }
    
    @objc fileprivate func selectorX() {
        
    }
}
