//
//  ButtonCollectionViewCell.swift
//  In*
//
//  Created by Mohammad Sulthan on 22/08/22.
//

import UIKit

enum ButtonType: String {
    case primary, secondary, link
}

protocol ButtonDelegate: AnyObject {
    func buttonTapped(_ id: String)
}

class ButtonCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ButtonDelegate?
    
    var identifier: ButtonIdentifier? {
        didSet {
            setupView()
        }
    }

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        if identifier?.type == .primary {
            button.setTitle(identifier?.title ?? "Button", for: .normal)
            button.backgroundColor = .primary
            button.layerCornerRadius = 4
            button.tintColor = .white
        } else if identifier?.type == .secondary {
            button.setTitle(identifier?.title ?? "Button", for: .normal)
            button.backgroundColor = .white
            button.layerCornerRadius = 4
            button.tintColor = .systemRed
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        delegate?.buttonTapped(identifier?.id ?? "")
    }
}
