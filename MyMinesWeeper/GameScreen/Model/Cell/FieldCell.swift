//
//  FieldCell.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 20.10.22.
//

import Foundation

struct FieldCell {

    var section: Int = 0
    var row: Int = 0
    
    var isEnable = true
    
     //TODO: enum Indicator -1 0 1..3..4..8
    var indicator: Int = 0 {
        didSet {
            isMine = indicator == -1 ? true : false
        }
    }
    
    var mineImage = "staroflife.fill"
    var isMine = false
    
    public func countMinesAround() -> String {
        return String(indicator)
    }
    
    mutating public func updateValue(fieldCell: FieldCell) {
        indicator = fieldCell.indicator
        section = fieldCell.section
        row = fieldCell.row
        isMine = fieldCell.isMine
    }
    
}
