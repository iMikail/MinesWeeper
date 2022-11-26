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
    
    var notSelectedCeelsCount: ((Int) -> ())?
    var pressedCellsDict = [String:Int]() {
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
        
        var dict = [String:Int]()
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
        
        let i = indexPath.section
        let j = indexPath.row
        
        fieldBuilder.field[i][j].isPressed = true
        if fieldBuilder.field[i][j].isMine {
            fieldBuilder.field[i][j].isSelectedMine = true
        }
        pressedCellsDict["\(i)&\(j)"] = 0
        
        if fieldBuilder.field[i][j].indicator == 0 {
            let emptyCells = gameFunctions.fetchEmptyCells(section: i, row: j, field: fieldBuilder.field)
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
