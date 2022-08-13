//
//  InventoryTableViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 05/08/22.
//

import UIKit

class InventoryTableViewCell: UITableViewCell {

    @IBOutlet weak var displayValue: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    @IBOutlet weak var brandValue: UILabel!
    @IBOutlet weak var typeValue: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = UIImage(systemName: "arrow.right")
        purchaseButton.setImage(icon, for: .normal)
        purchaseButton.imageView?.contentMode = .scaleAspectFit
        purchaseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        purchaseButton.setTitle("Purchase", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
