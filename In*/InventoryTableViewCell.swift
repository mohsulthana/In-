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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
