//
//  Difficulty.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

class FieldDifficulty {
    var fieldSize: FieldSizeProtocol
    var bombsCount: Int
    var time: Int?
    var recordType: RecordType?

    var cellsCount: Int { fieldSize.section * fieldSize.row }
    var maxBombsCount: Int { cellsCount - Constants.minFieldSize }
    var cellsCountForWin: Int { cellsCount - bombsCount }

    init(fieldSize: FieldSizeProtocol, bombsCount: Int, time: Int? = nil, difficulty: Difficulty? = nil) {
        self.fieldSize = fieldSize
        self.bombsCount = bombsCount
        self.time = time
        self.recordType = difficulty?.recordType
    }

    static func description(forFieldDifficulty fieldDifficulty: FieldDifficulty) -> String {
        let size = "Размер поля: \(fieldDifficulty.fieldSize.row)x\(fieldDifficulty.fieldSize.section)"
        let bombCount = "Количество бомб: \(fieldDifficulty.bombsCount)"
        var timeString = "Без таймера"
            if let time = fieldDifficulty.time {
                timeString = "Таймер \(time) секунд"
            }

        return size + "\n" + bombCount + "\n" + timeString
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
            return FieldDifficulty(fieldSize: fieldSize, bombsCount: 20, time: 300, difficulty: .easy)
        case .medium:
            fieldSize = FieldSize(section: 25, row: 25)
            return FieldDifficulty(fieldSize: fieldSize, bombsCount: 70, time: 480, difficulty: .medium)
        case .hard:
            fieldSize = FieldSize(section: 40, row: 40)
            return FieldDifficulty(fieldSize: fieldSize, bombsCount: 200, time: 600, difficulty: .hard)
        case .yourChoise:
            return FieldDifficulty(fieldSize: fieldSize, bombsCount: 10)
        }
    }

    var recordType: RecordType? {
        switch self {
        case .easy:
            return .easy
        case .medium:
            return .medium
        case .hard:
            return .hard
        case .yourChoise:
            return nil
        }
    }
}