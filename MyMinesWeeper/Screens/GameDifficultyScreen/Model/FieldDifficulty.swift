//
//  FieldDifficulty.swift
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
    var maxBombsCount: Int { cellsCount - DefaultOptions.minFieldSize }
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
        switch self {
        case .easy:
            return FieldDifficulty(fieldSize: DefaultOptions.Easy.fieldSize,
                                   bombsCount: DefaultOptions.Easy.bombCount,
                                   time: DefaultOptions.Easy.time,
                                   difficulty: DefaultOptions.Easy.difficulty)
        case .medium:
            return FieldDifficulty(fieldSize: DefaultOptions.Medium.fieldSize,
                                   bombsCount: DefaultOptions.Medium.bombCount,
                                   time: DefaultOptions.Medium.time,
                                   difficulty: DefaultOptions.Medium.difficulty)
        case .hard:
            return FieldDifficulty(fieldSize: DefaultOptions.Hard.fieldSize,
                                   bombsCount: DefaultOptions.Hard.bombCount,
                                   time: DefaultOptions.Hard.time,
                                   difficulty: DefaultOptions.Hard.difficulty)
        case .yourChoise:
                return FieldDifficulty(fieldSize: FieldSize(section: DefaultOptions.minFieldSize,
                                                            row: DefaultOptions.maxFieldSize),
                                       bombsCount: DefaultOptions.minBombsCount)
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
