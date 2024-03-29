//
//  DefaultOptions.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 27.10.22.
//

struct DefaultOptions {
    // MARK: - Min/Max
    static let minFieldSize = 15
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

    private init() {}
}

// MARK: - Segues identifiers
enum Segues: String {
    case fromMainVCToGameDifficultyVC
    case fromMainVCToOptionsVC
    case fromGameDifficultyVCToGameVC
    case fromGameVCToRecordsVC
    case fromGameVCToInfoVC
}

// MARK: - UserDefaults keys
enum UserDefaultsKeys: String {
    case currentNickName
    case defaultNickName = "незнакомец"
    case timerOptions
    case notFirstStartApp
}

enum ImageName: String {
    case bombBoomImage
    case bombImage
    case defusedBombImage
    case flagImage
    case startWarningImage
    case flagButtonImage
    case pauseImage
    case timerOnImage
    case timerOffImage
    case backgroundGeneral
    case backgroundRecords
}
