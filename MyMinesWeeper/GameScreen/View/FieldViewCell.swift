//
//  FieldCell.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit

class FieldViewCell: UICollectionViewCell {
    
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
      
    
    // MARK: - Functions
    // reload all view from cell
    public func reloadView(fieldCell: FieldCell) {
        isUserInteractionEnabled = fieldCell.isEnable
        reloadTextLabel(fieldCell: fieldCell)
        reloadImageView(fieldCell: fieldCell)
        self.layer.backgroundColor = UIColor.white.cgColor
    }
    // reload view Game Over
    public func reloadViewForBomb(fieldCell: FieldCell) {
        reloadImageView(fieldCell: fieldCell)
        self.layer.backgroundColor = UIColor.red.cgColor
    }
    // set standart view
    public func setCellView() {
        isUserInteractionEnabled = true
        imageView.isHidden = true
        textLabel.isHidden = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.backgroundColor = UIColor.gray.cgColor

    }
    // reload textLabel
    private func reloadTextLabel(fieldCell: FieldCell) {
        
        switch fieldCell.indicator {
            case -1:
                text(isHidden: true, color: .black)
            case 1...2:
                text(isHidden: false, color: .green)
            case 3...4:
                text(isHidden: false, color: .orange)
            case 5...8:
                text(isHidden: false, color: .red)
            default: break
        }

        func text(isHidden: Bool, color: UIColor) {
            textLabel.text = fieldCell.countMinesAround()
            textLabel.isHidden = isHidden
            textLabel.textColor = color
        }
    }
    // reload imageView
    private func reloadImageView(fieldCell: FieldCell) {
        
        if fieldCell.isMine {
            imageView.image = UIImage(systemName: fieldCell.mineImage)
            imageView.isHidden = false
        } 
    }
    
}
