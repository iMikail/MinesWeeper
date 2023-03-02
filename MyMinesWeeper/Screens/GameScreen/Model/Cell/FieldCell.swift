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

    var mineImage = "staroflife.fill"
    var isMine = false
    var isSelectedMine = false

    var flagImage = "flag.fill"
    var isFlag = false

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
