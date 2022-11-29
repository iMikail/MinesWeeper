//
//  RecordsManager.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 28.11.22.
//

import Foundation

class RecordsManager {
    
    static let shared: RecordsManager = RecordsManager()
    
    // 0-easy/1-medium/2-hard
    var records = Array(repeating: [Record](), count: RecordType.allCases.count) {
        didSet {
            for (i, item)  in records.enumerated() {
                records[i] = item.sorted { $0.time < $1.time }
                while records[i].count > Constants.countRecordsForEachSection {
                    records[i].removeLast()
                }
            }
        }
    }
    
    private init() {}
    
    func getRecords(forType type: RecordType) -> [Record] {
        return records[type.rawValue]
    }
    
    func addRecord(_ record: Record) {
        records[record.type.rawValue].append(record)
    }
    
    func resetRecords(forType type: RecordType) {
        records[type.rawValue].removeAll()
        print("delete records")
    }
    
    
}
