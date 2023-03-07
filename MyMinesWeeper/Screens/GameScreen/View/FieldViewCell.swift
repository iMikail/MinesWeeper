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
        layer.backgroundColor = UIColor.white.cgColor
        reloadTextLabel()
        reloadImageView()
    }
    // set standart view
    public func setCellView() {
        isUserInteractionEnabled = true
        imageView.isHidden = true
        textLabel.isHidden = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        layer.backgroundColor = UIColor.lightGray.cgColor
        updateFlagImage()
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
        if fieldCell.isFlag {
            removeFlagImage()
        }
        if fieldCell.isMine {
            imageView.image = UIImage(named: fieldCell.mineImage)
            imageView.isHidden = false

            if fieldCell.isSelectedMine {
                imageView.image = UIImage(named: fieldCell.bombBoomImage)
                layer.backgroundColor = UIColor.systemRed.cgColor
            } else {
                layer.backgroundColor = UIColor.systemGray3.cgColor
            }

            if fieldCell.isFlag {
                imageView.image = UIImage(named: fieldCell.defusedBombImage)
                layer.backgroundColor = UIColor.systemGreen.cgColor
            }
        }
    }

    private func updateFlagImage() {
        if fieldCell.isFlag {
            setupFlagImage()
        } else {
            removeFlagImage()
        }
    }

    private func setupFlagImage() {
        imageView.tintColor = .red
        imageView.image = UIImage(named: fieldCell.flagImage)
        imageView.isHidden = false
    }

    private func removeFlagImage() {
        imageView.tintColor = .black
        imageView.image = nil
        imageView.isHidden = true
    }
}
