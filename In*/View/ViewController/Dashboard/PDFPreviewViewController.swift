//
//  PDFPreviewViewController.swift
//  876 Inventory
//
//  Created by Mohammad Sulthan on 03/09/22.
//

import UIKit
import PDFKit
import LinkPresentation

class PDFPreviewViewController: UIViewController {
    
    var documentData: Data?
    var pdfView: PDFView!
    weak var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Invoice"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(downloadPDF(_:)))
        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
        pdfView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        view.addSubview(pdfView)
        
        if let data = documentData {
            pdfView.document = PDFDocument(data: data)
            pdfView.autoScales = true
        }
    }
    
    @objc private func downloadPDF(_ sender: UIBarButtonItem) {
        if let order = order {
            
            let pdfCreator = PDFCreator(title: "876 Inventory Invoice", logo: UIImage(named: "logo") ?? UIImage(), date: order.createdOn ?? Date(), invoice: order.invoice, name: order.product?.name ?? "", brand: order.product?.brand ?? "", type: order.product?.type ?? "", quantity: order.quantity, price: order.totalPrice)
            let pdfData = pdfCreator.createFlyer()
            let vc = UIActivityViewController(activityItems: [pdfData], applicationActivities: [])
            present(vc, animated: true, completion: nil)
        }
    }
}
