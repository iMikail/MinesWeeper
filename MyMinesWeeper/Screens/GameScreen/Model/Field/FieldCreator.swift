//
//  FieldCreator.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

class FieldCreator: FieldCreatorProtocol {
    var fieldSize: FieldSizeProtocol

    init(fieldSize: FieldSizeProtocol) {
        self.fieldSize = fieldSize
    }

    public func createField() -> FieldArray {

        var array = FieldArray()
        for section in 0..<fieldSize.section {
            array.append([])
            for row in 0..<fieldSize.row {
                array[section].append(FieldCell(section: section, row: row))
            }
        }

        return array
    }

}
