//
//  GameFunctions.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 25.10.22.
//

import Foundation

class MinesWeeper {
    // MARK: - Variables
    var fieldBuilder: FieldBuilderProtocol
    var gameFunctions: GameFunctions

    let fieldDifficulty: FieldDifficulty

    var notSelectedCeelsCount: ((Int) -> Void)?
    var pressedCellsDict = [String: Int]() {
        didSet {
            notSelectedCeelsCount?(fieldDifficulty.cellsCount - pressedCellsDict.count)
        }
    }

    // MARK: - Init
    init(fieldDifficulty: FieldDifficulty) {
        self.fieldDifficulty = fieldDifficulty
        fieldBuilder = FieldBuilder(fieldSize: fieldDifficulty.fieldSize)
        gameFunctions = GameFunctions()
        gameFunctions.setBombs(bombs: generateBombs(), field: &fieldBuilder.field)
    }

    // MARK: - Functions
    public func resetGame() {
        fieldBuilder.resetField()
        pressedCellsDict.removeAll()
        gameFunctions.setBombs(bombs: generateBombs(), field: &fieldBuilder.field)
    }

    private func generateBombs() -> [[Int]] {
        var dict = [String: Int]()
        var bombs = [[Int]]()

        while bombs.count < fieldDifficulty.bombsCount {

            let section = Int.random(in: 0..<fieldDifficulty.fieldSize.section)
            let row = Int.random(in: 0..<fieldDifficulty.fieldSize.row)

            if dict["\(section)&\(row)"] == nil {
                bombs.append([section, row])
                dict["\(section)&\(row)"] = 1
            }
        }

        return bombs
    }

    public func selectedCells(indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row

        fieldBuilder.field[section][row].isPressed = true
        if fieldBuilder.field[section][row].isMine {
            fieldBuilder.field[section][row].isSelectedMine = true
        }
        pressedCellsDict["\(section)&\(row)"] = 0

        if fieldBuilder.field[section][row].indicator == 0 {
            let emptyCells = gameFunctions.fetchEmptyCells(section: section, row: row, field: fieldBuilder.field)
            emptyCells.forEach { point in
                fieldBuilder.field[point[0]][point[1]].isPressed = true
                pressedCellsDict["\(point[0])&\(point[1])"] = 0 // for checkWin
            }
        }
    }

    public func checkWin() -> Bool {
        //test
        print("Need cells for win: ", fieldDifficulty.cellsCountForWin)
        print("selected cells: ", pressedCellsDict.count)

        return fieldDifficulty.cellsCountForWin == pressedCellsDict.count ? true : false
    }
}
