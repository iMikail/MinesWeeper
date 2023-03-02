//
//  DefaultOptions.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 27.10.22.
//

struct DefaultOptions {
    // MARK: - Min/Max
    static let minFieldSize = 10
    static let maxFieldSize = 100
    static let minBombsCount = 10
    static let minTime = 60
    static let maxTime = 3600

    // MARK: - Field difficulty: size, bombs, time
    struct Easy {
        static let fieldSize = FieldSize(section: 15, row: 15)
        static let bombCount = 20
        static let time = 300
        static let difficulty: Difficulty = .easy
    }

    struct Medium {
        static let fieldSize = FieldSize(section: 25, row: 25)
        static let bombCount = 70
        static let time = 480
        static let difficulty: Difficulty = .medium
    }

    struct Hard {
        static let fieldSize = FieldSize(section: 40, row: 40)
        static let bombCount = 200
        static let time = 600
        static let difficulty: Difficulty = .hard
    }

    // MARK: - Count records in table
    static let countRecordsForEachSection = 7

    // MARK: - NickName
    static let currentNickName = "currentNickName"
    static let defaultNickName = "незнакомец"

    private init() {}
}
