//
//  DataDetailCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 24/08/22.
//

import UIKit

class DataDetailCollectionViewCell: UICollectionViewCell {
    
    weak var identifier: DataDetailIdentifier? {
        didSet {
            setupView()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        titleLabel.textColor = .label
        valueLabel.textColor = .secondaryLabel
        
        titleLabel.text = identifier?.title
        valueLabel.text = identifier?.value
    }
}
