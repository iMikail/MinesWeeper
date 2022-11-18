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
    // Score for win
    lazy private var winsCount = fieldDifficulty.fieldSize.section * fieldDifficulty.fieldSize.row - fieldDifficulty.bombsCount {
        didSet {
            dictForWin.removeAll()
        }
    }
    
    private var dictForWin = [String:Int]()
    
    // MARK: - Init
    init(fieldDifficulty: FieldDifficulty) {
        self.fieldDifficulty = fieldDifficulty
        fieldBuilder = FieldBuilder(fieldSize: fieldDifficulty.fieldSize)
        gameFunctions = GameFunctions()
        let bombs = generateBombs(fieldOptions: fieldDifficulty)
        gameFunctions.setBombs(bombs: bombs, field: &fieldBuilder.field)
    }
    
    // MARK: - Functions
    // reset field & bombs
    public func resetGame() {
        fieldBuilder.resetField()
        let bombs = generateBombs(fieldOptions: fieldDifficulty)
        gameFunctions.setBombs(bombs: bombs, field: &fieldBuilder.field)
    }
    
    // generate bombs
    public func generateBombs(fieldOptions: FieldDifficulty) -> [[Int]] {
        
        var dict = [String:Int]()
        var bombs = [[Int]]()
        
        while bombs.count < fieldDifficulty.bombsCount {
            
            let section = Int.random(in: 0..<fieldOptions.fieldSize.section)
            let row = Int.random(in: 0..<fieldOptions.fieldSize.row)
            
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
        
        fieldBuilder.field[i][j].isEnable = false
        dictForWin["\(i)&\(j)"] = 0
        
        if fieldBuilder.field[i][j].indicator == 0 {
            let emptyCells = gameFunctions.fetchEmptyCells(section: i, row: j, field: fieldBuilder.field)
            emptyCells.forEach { point in
                fieldBuilder.field[point[0]][point[1]].isEnable = false
                dictForWin["\(point[0])&\(point[1])"] = 0 // for checkWin
            }
        }
    }
    
    public func checkWin() -> Bool {
        //test
        print("Need cells for win: ", winsCount)
        print("selected cells: ", dictForWin.count)
        print("cells for wins: \(winsCount - dictForWin.count)")
        
        return winsCount == dictForWin.count ? true : false
    }
    
}
