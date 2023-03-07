//
//  RecordsTableViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class RecordsTableViewController: UITableViewController {
    let cellIdentifier = "recordCell"

    var resetButtons: [UIButton]!

    lazy var backgroundView: UIImageView = {
        let view = UIImageView(frame: tableView.frame)
        view.image = UIImage(named: ImageName.backgroundRecords.rawValue)
        view.contentMode = .scaleToFill

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        resetButtons = Array(repeating: createResetButton(), count: RecordType.allCases.count)
        tableView.backgroundView = backgroundView
    }

    private func setupResetButton(forSection section: Int) {
        resetButtons[section] = createResetButton()

        if let type = RecordType(rawValue: section) {
            if (RecordsManager.shared.getRecords(forType: type)).isEmpty {
                resetButtons[section].isEnabled = false
            }
        }

        let action = UIAction { [weak self] _ in
            if let type = RecordType(rawValue: section) {
                RecordsManager.shared.removeRecords(forType: type)
                self?.resetButtons[section].isEnabled = false
                self?.tableView.reloadSections(IndexSet(integer: section), with: .fade)
            }
        }
        resetButtons[section].addAction(action, for: .touchUpInside)
    }

    private func createResetButton() -> UIButton {
        let button = UIButton(configuration: .plain())
        button.frame = CGRect(x: tableView.bounds.width / 2 - 100, y: 0,
                              width: 200, height: 30)

        let title = "Сбросить рекорды"
        let attrEnabled = [NSAttributedString.Key.foregroundColor: UIColor.red,
                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let attrDisabled = [NSAttributedString.Key.foregroundColor: UIColor.gray,
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attrEnabled), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attrDisabled), for: .disabled)

        return button
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return RecordType.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = RecordType(rawValue: section) else { return 0 }
        let records = RecordsManager.shared.getRecords(forType: section)

        return records.count
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        setupResetButton(forSection: section)

        let view = UIView()
        view.addSubview(resetButtons[section])

        return view
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = RecordType(rawValue: section) else { return nil }
        var text = " сложность:"
        switch section {
        case .easy:
            text = "Лёгкая" + text
        case .medium:
            text = "Средняя" + text
        case .hard:
            text = "Тяжёлая" + text
        }
        return text
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? RecordCell else {
            print("Record cell not created")
            return UITableViewCell()
        }

        if let recordType = RecordType(rawValue: indexPath.section) {
            let records = RecordsManager.shared.getRecords(forType: recordType)
            cell.record = records[indexPath.row]
        }
        return cell
    }
}
