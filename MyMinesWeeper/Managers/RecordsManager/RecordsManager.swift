//
//  RecordsManager.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 28.11.22.
//

import Foundation

typealias RecordsArray = [[Record]]

final class RecordsManager {
    static let shared: RecordsManager = RecordsManager()

    // MARK: - Variables
    private let coreDataManager = CoreDataManager()

    // 0-easy/1-medium/2-hard
    private var records = Array(repeating: [Record](), count: RecordType.allCases.count) {
        didSet {
            for (ind, item) in records.enumerated() {
                records[ind] = item.sorted { $0.time < $1.time }
                if records[ind].count > DefaultOptions.countRecordsForEachSection {
                    records[ind].removeLast()
                }
            }
            saveData()
        }
    }

    // MARK: - Init
    private init() {
        if let data = coreDataManager.fetchStoreRecordsData() {
            do {
                records = try JSONDecoder().decode(RecordsArray.self, from: data)
            } catch {
                print("RecordsManager: \(error)")
            }
        } else {
            records = createAIRecords()
        }
    }

    // MARK: - Functions
    func getRecords(forType type: RecordType) -> [Record] {
        return records[type.rawValue]
    }

    func addRecord(_ record: Record) {
        records[record.type.rawValue].append(record)
    }

    func removeRecords(forType type: RecordType) {
        records[type.rawValue].removeAll()
    }

    func resetAllRecords() {
        RecordType.allCases.forEach { removeRecords(forType: $0) }
        records = createAIRecords()
    }

    private func saveData() {
        do {
            let data = try JSONEncoder().encode(records)
            coreDataManager.updateRecords(fromData: data)
        } catch {
            print("RecordsManager: \(error)")
        }
    }

    private func createAIRecords() -> RecordsArray {
        let records = [
            [Record(time: 80, nickName: "СложныйAI", type: .easy),
             Record(time: 130, nickName: "СреднийAI", type: .easy),
             Record(time: 190, nickName: "ЛёгкийAI", type: .easy)],
            [Record(time: 290, nickName: "СложныйAI", type: .medium),
             Record(time: 380, nickName: "СреднийAI", type: .medium),
             Record(time: 440, nickName: "ЛёгкийAI", type: .medium)],
            [Record(time: 410, nickName: "СложныйAI", type: .hard),
             Record(time: 470, nickName: "СреднийAI", type: .hard),
             Record(time: 540, nickName: "ЛёгкийAI", type: .hard)]]

        return records
    }
}
