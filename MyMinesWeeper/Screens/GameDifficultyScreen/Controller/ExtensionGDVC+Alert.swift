//
//  ExtensionGDVC+Alert.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 10.11.22.
//

import UIKit

extension GameDifficultyViewController {
    // MARK: - AlertController for yourChoise
     func difficultyAlertController() {
        let alertController: UIAlertController = {
            let alert = UIAlertController(title: "Ваш выбор",
                                          message: "Укажите параметры",
                                          preferredStyle: .alert)

            let beginAction = UIAlertAction(title: "Играть", style: .default) { [weak self] _ in
                self?.performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
            }
            let canselAction = UIAlertAction(title: "Отмена", style: .cancel)
            beginAction.isEnabled = false
            alert.addTextField { textField in
                textField.text = "Укажите ширину поля(10-100)"
                textField.isEnabled = false
            }
            alert.addTextField { textField in
                textField.placeholder = "22"
            }
            alert.addTextField { textField in
                textField.text = "Укажите высоту поля(10-100)"
                textField.isEnabled = false
            }
            alert.addTextField { textField in
                textField.placeholder = "33"
            }

            alert.addTextField { textField in
                textField.text = "Укажите количество мин(>10)"
                textField.isEnabled = false
            }
            alert.addTextField { textField in
                textField.placeholder = "44"
            }
            alert.textFields?.forEach { textField in
                if textField.isEnabled {
                    textField.keyboardType = .numberPad
                    // add observer for enable button begin
                    NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                           object: textField,
                                                           queue: OperationQueue.main) { [weak self] _ in
                        guard let self = self else { return }

                        beginAction.isEnabled = self.setOptionsFromTextFields(alert.textFields)
                    }
                }
            }

            alert.addAction(beginAction)
            alert.addAction(canselAction)

            return alert
        }()

        present(alertController, animated: true)
    }

    private func setOptionsFromTextFields(_ textFields: [UITextField]?) -> Bool {
        guard let rowStr = textFields?[1].text,
              let sectionStr = textFields?[3].text,
              let bombCountStr = textFields?[5].text else { return false }

        if let section = Int(sectionStr),
           let row = Int(rowStr),
            let bombCount = Int(bombCountStr) {
            fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: section, row: row), bombsCount: bombCount)
            return true
        }

        return false
    }

}
