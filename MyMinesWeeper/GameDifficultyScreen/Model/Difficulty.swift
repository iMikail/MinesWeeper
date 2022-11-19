//
//  Difficulty.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import Foundation

class FieldDifficulty {
    var fieldSize: FieldSizeProtocol
    var bombsCount: Int
    
    init(fieldSize: FieldSizeProtocol, bombsCount: Int) {
        self.fieldSize = fieldSize
        self.bombsCount = bombsCount
    }
}

enum Difficulty: String {
    case easy = "Легко"
    case medium = "Средне"
    case hard = "Тяжело"
    case yourChoise = "Ваш выбор"
    
    var fieldDifficulty: FieldDifficulty {
        var fieldSize = FieldSize(section: 15, row: 15)
        switch self {
            case .easy:
                return FieldDifficulty(fieldSize: fieldSize, bombsCount: 20)
            case .medium:
                fieldSize = FieldSize(section: 25, row: 25)
                return FieldDifficulty(fieldSize: fieldSize, bombsCount: 70)
            case .hard:
                fieldSize = FieldSize(section: 40, row: 40)
                return FieldDifficulty(fieldSize: fieldSize, bombsCount: 200)
            case .yourChoise:
                return FieldDifficulty(fieldSize: fieldSize, bombsCount: 10)
        }
    }
}
