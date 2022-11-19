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
    private var winsCount: Int {
        didSet {
            selectedCellsDict.removeAll()
        }
    }
    
    var count: ((Int) -> ())?
    var selectedCellsDict = [String:Int]() {
        didSet {
            count?(fieldDifficulty.fieldSize.section * fieldDifficulty.fieldSize.row - selectedCellsDict.count)
        }
    }
    

    
    // MARK: - Init
    init(fieldDifficulty: FieldDifficulty) {
        self.fieldDifficulty = fieldDifficulty
        fieldBuilder = FieldBuilder(fieldSize: fieldDifficulty.fieldSize)
        gameFunctions = GameFunctions()
        winsCount = fieldDifficulty.fieldSize.section * fieldDifficulty.fieldSize.row - fieldDifficulty.bombsCount
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
        
        fieldBuilder.field[i][j].isPressed = true
        if fieldBuilder.field[i][j].isMine {
            fieldBuilder.field[i][j].isSelectedMine = true
        }
        selectedCellsDict["\(i)&\(j)"] = 0
        
        if fieldBuilder.field[i][j].indicator == 0 {
            let emptyCells = gameFunctions.fetchEmptyCells(section: i, row: j, field: fieldBuilder.field)
            emptyCells.forEach { point in
                fieldBuilder.field[point[0]][point[1]].isPressed = true
                selectedCellsDict["\(point[0])&\(point[1])"] = 0 // for checkWin
            }
        }
    }
    
    public func checkWin() -> Bool {
        //test
        print("Need cells for win: ", winsCount)
        print("selected cells: ", selectedCellsDict.count)
        print("cells for wins: \(winsCount - selectedCellsDict.count)")
        
        return winsCount == selectedCellsDict.count ? true : false
    }
    
}
