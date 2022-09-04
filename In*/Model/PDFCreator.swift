//
//  PDFCreator.swift
//  876 Inventory
//
//  Created by Mohammad Sulthan on 01/09/22.
//

import PDFKit
import UIKit

class PDFCreator: NSObject {
    let title: String
    let logo: UIImage
    let date: Date
    let invoiceNumber: Int16
    let productName: String
    let brand: String
    let type: String
    let quantity: Int16
    let price: Double

    init(title: String, logo: UIImage, date: Date, invoice: Int16, name: String, brand: String, type: String, quantity: Int16, price: Double) {
        self.title = title
        self.logo = logo
        self.date = date
        self.productName = name
        self.brand = brand
        self.type = type
        self.invoiceNumber = invoice
        self.quantity = quantity
        self.price = price
    }

    func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        
        let invoiceFont = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        let invoiceAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: invoiceFont]
        let attributedInvoice = NSAttributedString(
            string: "#\(invoiceNumber)",
            attributes: invoiceAttributes
        )

        let titleStringSize = attributedTitle.size()
        let invoiceStringSize = attributedInvoice.size()

        let titleStringRect = CGRect(
            x: (pageRect.width - titleStringSize.width) / 2.0,
            y: 36,
            width: titleStringSize.width,
            height: titleStringSize.height
        )
        
        let invoiceStringRect = CGRect (
            x: (pageRect.width - invoiceStringSize.width) / 2.0,
            y: titleStringRect.origin.y + 24,
            width: invoiceStringSize.width,
            height: invoiceStringSize.height
        )

        attributedTitle.draw(in: titleStringRect)
        attributedInvoice.draw(in: invoiceStringRect)
        return titleStringRect.origin.y + (titleStringRect.size.height + invoiceStringRect.size.height)
    }

    func createFlyer() -> Data {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "876 Inventory",
            kCGPDFContextAuthor: "Jonte",
            kCGPDFContextTitle: title,
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]

        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        // 3
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/YYY"
            
            context.beginPage()
            let title = addTitle(pageRect: pageRect)
            addImage(pageRect: pageRect)
            addBodyText(text: "Product Name", content: productName, pageRect: pageRect, textTop: title + 16)
            addBodyText(text: "Created On", content: dateFormatter.string(from: date), pageRect: pageRect, textTop: title + 64)
            addBodyText(text: "Brand", content: brand, pageRect: pageRect, textTop: title + 108)
            addBodyText(text: "Total Price", content: "$\(price)", pageRect: pageRect, textTop: title + 154)
            addBodyText(text: "Type", content: type, pageRect: pageRect, textTop: title + 200)
            addBodyText(text: "Quantity", content: "\(quantity) pcs", pageRect: pageRect, textTop: title + 244)
        }

        return data
    }

    func addBodyText(text: String, content: String, pageRect: CGRect, textTop: CGFloat) {
        let textFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping

        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
        ]
        let titleAttributedText = NSAttributedString(
            string: text,
            attributes: titleAttributes
        )
        
        let subtitleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: UIColor.primary
        ]
        
        let subtitleAttributedText = NSAttributedString(
            string: content,
            attributes: subtitleAttributes as [NSAttributedString.Key : Any]
        )
        
        let titleRect = CGRect(x: 16, y: textTop, width: pageRect.width - 16, height: pageRect.height - textTop - pageRect.height / 5.0)

        let subtitleRect = CGRect(
            x: 16,
            y: titleRect.origin.y + 16,
            width: pageRect.width - 20,
            height: pageRect.height - textTop - pageRect.height / 5.0
        )
        
        titleAttributedText.draw(in: titleRect)
        subtitleAttributedText.draw(in: subtitleRect)
    }

    func addImage(pageRect: CGRect) {
        
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.8

        let imageRect = CGRect(x: pageRect.width - (40 + 36), y: 36,
                               width: 40, height: 40)
        
        logo.draw(in: imageRect)
    }
}
