//
//  FieldSize.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 12.11.22.
//

class FieldSize: FieldSizeProtocol {
    var section: Int
    var row: Int

    init(section: Int, row: Int) {
        self.section = section
        self.row = row
    }

}
