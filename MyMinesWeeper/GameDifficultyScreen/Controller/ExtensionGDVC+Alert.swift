//
//  ExtensionGDVC+Alert.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 10.11.22.
//

import Foundation
import UIKit

extension GameDifficultyViewController {
    
    // MARK: - AlertController for yourChoise
     func difficultyAlertController() {
        let alertController: UIAlertController = {
            let ac = UIAlertController(title: "Ваш выбор", message: "Укажите параметры", preferredStyle: .alert)
            
            let beginAction = UIAlertAction(title: "Играть", style: .default) { [weak self] action in
                self?.performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
            }
            let canselAction = UIAlertAction(title: "Отмена", style: .cancel)
            beginAction.isEnabled = false
            ac.addTextField { textField in
                textField.text = "Укажите высоту поля(10-100)"
                textField.isEnabled = false
            }
            ac.addTextField() { textField in
                textField.placeholder = "22"
            }
            ac.addTextField { textField in
                textField.text = "Укажите ширину поля(10-100)"
                textField.isEnabled = false
            }
            ac.addTextField() { textField in
                textField.placeholder = "33"
            }
            
            ac.addTextField { textField in
                textField.text = "Укажите количество мин(>10)"
                textField.isEnabled = false
            }
            ac.addTextField() { textField in
                textField.placeholder = "44"
            }
            ac.textFields?.forEach { textField in
                if textField.isEnabled {
                    textField.keyboardType = .numberPad
                    // add observer for enable button begin
                    NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { [weak self] _ in
                        guard let self = self else { return }
                        beginAction.isEnabled = self.setOptionsFromTextFields(ac.textFields)
                    }
                }
            }
            
            ac.addAction(beginAction)
            ac.addAction(canselAction)
            
            return ac
        }()
        
        present(alertController, animated: true)
    }
    
    private func setOptionsFromTextFields(_ textFields: [UITextField]?) -> Bool {
        guard let sectionStr = textFields?[1].text,
              let rowStr = textFields?[3].text,
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
