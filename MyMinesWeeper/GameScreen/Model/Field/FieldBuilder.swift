//
//  FieldData.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

class FieldBuilder: FieldBuilderProtocol {
    
    internal var fieldCreator: FieldCreatorProtocol
    var field: FieldArray
    
    required init(fieldSize: FieldSizeProtocol) {
        fieldCreator = FieldCreator(fieldSize: fieldSize)
        field = fieldCreator.createField()
    }

    public func resetField() {
        field = fieldCreator.createField()
    }
    
    public func deEnableAllCells() {
        field.forEach { $0.forEach { field[$0.section][$0.row].isPressed = true } }
    }
    
    
    //    public func updateFieldFor(_ cells: [FieldCell]) {
    //        cells.forEach { cell in
    //            field[cell.section][cell.row].updateValue(fieldCell: cell)
    //        }
    //    }
}

