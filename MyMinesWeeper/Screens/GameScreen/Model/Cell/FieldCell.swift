//
//  FieldCell.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 20.10.22.
//

struct FieldCell {
    var section: Int = 0
    var row: Int = 0
    var isPressed = false
    var indicator: Int = 0 {
        didSet {
            isMine = indicator == -1 ? true : false
        }
    }

    var mineImage = ImageName.bombImage.rawValue
    var isMine = false
    var isSelectedMine = false

    var flagImage = ImageName.flagImage.rawValue
    var isFlag = false

    var bombBoomImage = ImageName.bombBoomImage.rawValue
    var defusedBombImage = ImageName.defusedBombImage.rawValue

    public func countMinesAround() -> String {
        return String(indicator)
    }

    public mutating func toggleFlag() {
        isFlag = !isFlag
    }

    mutating public func updateValue(fieldCell: FieldCell) {
        indicator = fieldCell.indicator
        section = fieldCell.section
        row = fieldCell.row
        isMine = fieldCell.isMine
        isFlag = fieldCell.isFlag
    }
}
