//
//  ExtensionGDVC+Alert.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 10.11.22.
//

import UIKit

extension GameDifficultyViewController {
    // MARK: - AlertController for yourChoise
    func difficultyAlertController(timerIsEnabled: Bool) -> UIAlertController {
        let alert = UIAlertController(title: "Ваш выбор", message: "Укажите параметры", preferredStyle: .alert)
        let beginAction = UIAlertAction(title: "Играть", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
        }
        let canselAction = UIAlertAction(title: "Отмена", style: .cancel)
        beginAction.isEnabled = false

        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, text: "Укажите ширину поля(10-100)")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, placeholder: "20", isEnable: true)
        }

        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, text: "Укажите высоту поля(10-100)")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, placeholder: "30", isEnable: true)
        }

        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, text: "Укажите количество мин(>10)")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextFieldInfo(textField, placeholder: "40", isEnable: true)
        }

        if timerIsEnabled {
            alert.addTextField { [weak self] textField in
                self?.configureTextFieldInfo(textField, text: "Укажите таймер в секундах(>60)")
            }
            alert.addTextField { [weak self] textField in
                self?.configureTextFieldInfo(textField, placeholder: "60", isEnable: true)
            }
        }

        alert.textFields?.forEach { textField in
            if textField.isEnabled {
                textField.keyboardType = .numberPad
                // add observer for enable button begin
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                       object: textField,
                                                       queue: OperationQueue.main) { [weak self] _ in
                    guard let self = self else { return }
                    beginAction.isEnabled = self.setOptionsFromTextFields(alert.textFields,
                                                                          timerIsEnable: timerIsEnabled)
                }
            }
        }

        alert.addAction(beginAction)
        alert.addAction(canselAction)

        return alert
    }

    private func setOptionsFromTextFields(_ textFields: [UITextField]?, timerIsEnable: Bool) -> Bool {
        guard let rowStr = textFields?[1].text,
              let sectionStr = textFields?[3].text,
              let bombCountStr = textFields?[5].text else { return false }

        if let section = Int(sectionStr),
           let row = Int(rowStr),
           let bombCount = Int(bombCountStr) {
            if timerIsEnable {
                guard let timeStr = textFields?[7].text else { return false }
                if let time = Int(timeStr) {
                    fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: section, row: row),
                                                      bombsCount: bombCount,
                                                      time: time)
                } else {
                    return false
                }
            } else {
                fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: section, row: row),
                                                  bombsCount: bombCount)
            }
            return true
        }

        return false
    }

    private func configureTextFieldInfo(_ textField: UITextField, text: String? = nil,
                                        placeholder: String? = nil, isEnable: Bool = false) {
        textField.text = text
        textField.placeholder = placeholder
        textField.isEnabled = isEnable
    }
}
