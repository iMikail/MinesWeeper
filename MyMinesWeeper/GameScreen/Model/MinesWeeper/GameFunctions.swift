//
//  GameFunctions.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import Foundation

class GameFunctions {
    
    // setting bombs on field
    public func setBombs(bombs: [[Int]], field: inout FieldArray) {
        
        guard bombs.count > 0 else {
            print("bombs array is empty")
            return
        }
        
        let section = field.count
        let row = field.first!.count
        
        for bomb in bombs {
            // fetch range for around cell
            let sectionMin = bomb[0] - 1 > 0 ? bomb[0] - 1 : 0
            let sectionMax = bomb[0] + 1 < section - 1 ? bomb[0] + 1: section - 1
            let rowMin = bomb[1] - 1 > 0 ? bomb[1] - 1 : 0
            let rowMax = bomb[1] + 1 < row - 1 ? bomb[1] + 1 : row - 1
            
            for i in sectionMin...sectionMax {
                for j in rowMin...rowMax {
                    field[i][j].indicator += 1 // setting bombs count for around cell
                }
            }
        }

        bombs.forEach {
            field[$0[0]][$0[1]].indicator = -1 // setting bomb
        }
        
    }
    
    // search all empty cells around selected cell
    public func fetchEmptyCells(section: Int, row: Int, field: FieldArray) -> [[Int]] {
     
        var dict = [String:[Int]]()
        var emptyCells = [[Int]]()
        let sectionCount = field.count - 1
        let rowCount = field.first!.count - 1
        
        func findEmptyCell(sectionPoint: Int, rowPoint: Int) {
            
            guard 0...sectionCount ~= sectionPoint && 0...rowCount ~= rowPoint else { return }
            guard dict["s\(sectionPoint)r\(rowPoint)"] == nil else { return }
            
            dict["s\(sectionPoint)r\(rowPoint)"] = [sectionPoint, rowPoint]
            
            let sectionMin = sectionPoint - 1 > 0 ? sectionPoint - 1 : 0
            let sectionMax = sectionPoint + 1 < sectionCount ? sectionPoint + 1 : sectionCount
            let rowMin = rowPoint - 1 > 0 ? rowPoint - 1 : 0
            let rowMax = rowPoint + 1 < rowCount ? rowPoint + 1 : rowCount
            
            for i in sectionMin...sectionMax {
                for j in rowMin...rowMax {
                    
                    if field[i][j].indicator == 0 {
                        findEmptyCell(sectionPoint: i, rowPoint: j)
                    } else if field[i][j].indicator > 0 {
                        dict["s\(i)r\(j)"] = [i, j]
                    }
                    
                }
            }
            
        }
        
        findEmptyCell(sectionPoint: section, rowPoint: row)
        
        dict.forEach { (_, value) in
            emptyCells.append(value)
        }

        // test
        print("dict: ", dict)
        print("count: ", dict.count)
        print("empty cellsDict: ", emptyCells)
        print("count: ", emptyCells.count)
        print("------")
        return emptyCells
    }
}
