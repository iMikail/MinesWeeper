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

    var fieldCell: FieldCell! {
        didSet {
            setCellView()
            if fieldCell.isPressed {
                reloadView()
            }
        }
    }

    // MARK: - Functions
    // reload all view from cell
    public func reloadView() {
        isUserInteractionEnabled = !fieldCell.isPressed
        self.layer.backgroundColor = UIColor.white.cgColor
        reloadTextLabel()
        reloadImageView()
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

    private func reloadTextLabel() {
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

    private func reloadImageView() {
        if fieldCell.isMine {
            imageView.image = UIImage(systemName: fieldCell.mineImage)
            imageView.isHidden = false
            if fieldCell.isSelectedMine {
                self.layer.backgroundColor = UIColor.systemRed.cgColor
            } else {
                self.layer.backgroundColor = UIColor.systemGray3.cgColor
            }
        }
    }
}
