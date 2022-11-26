//
//  RecordsTableViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    let cellIdentifier = "recordCell"

    // 0-easy/1-medium/2-hard
    var records = [[Record](), [Record](), [Record]()] {
        didSet {
            for (i, item)  in records.enumerated() {
                records[i] = item.sorted { $0.time < $1.time }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Рекорды"
        records = [
            [Record(time: 1234, nickName: "Foo", type: .easy),
             Record(time: 20000, nickName: "Fooooo1", type: .easy),
             Record(time: 4000, nickName: "Foo2", type: .easy),
             Record(time: 3000, nickName: "Foo3", type: .easy),
             Record(time: 5000, nickName: "Foo4", type: .easy),
             Record(time: 1000, nickName: "Foo5", type: .easy),
                   ],
            [Record(time: 10000, nickName: "Foo", type: .medium),
             Record(time: 2000, nickName: "Foo1", type: .medium),
             Record(time: 30000, nickName: "Foo2", type: .medium)
            ],
            [Record(time: 10234, nickName: "Foo", type: .hard),
             Record(time: 2000, nickName: "Foo1", type: .hard),
             Record(time: 3000, nickName: "Foo2", type: .hard)
            ]
        ]
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecordType.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = RecordType(rawValue: section) else { fatalError() }
        
        switch section {
            case .easy: return records[0].count
            case .medium: return records[1].count
            case .hard: return records[2].count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = RecordType(rawValue: section) else { fatalError() }
        
        var text = " сложность:"
        switch section {
            case .easy: text = "Лёгкая" + text
            case .medium: text =  "Средняя" + text
            case .hard: text = "Тяжёлая" + text
        }
        return text
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordCell else { fatalError("Record cell not created") }
        guard let recordType = RecordType(rawValue: indexPath.section) else { fatalError("RecordType not created") }

        switch recordType {
            case .easy: cell.record = records[0][indexPath.row]
            case .medium: cell.record = records[1][indexPath.row]
            case .hard: cell.record = records[2][indexPath.row]
        }
        return cell
    }
}
