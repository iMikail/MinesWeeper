//
//  Protocols.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 2.11.22.
//

import Foundation

typealias FieldArray = [[FieldCell]]

protocol FieldSizeProtocol {
    var section: Int { get set }
    var row: Int { get set }
}

protocol FieldCreatorProtocol {
    var fieldSize: FieldSizeProtocol { get set }
    func createField() -> FieldArray
}

protocol FieldBuilderProtocol {
    var fieldCreator: FieldCreatorProtocol { get }
    var field: FieldArray { get set }
    init(fieldSize: FieldSizeProtocol)
    func resetField()
    func deEnableAllCells()

 //   func updateFieldFor(_ cells: [FieldCell])
}
