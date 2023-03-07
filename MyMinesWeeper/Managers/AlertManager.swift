//
//  AlertManager.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 1.03.23.
//

import UIKit

final class AlertManager {
    func createNickNameAlert(
        nickName: String? = nil,
        _ completionHandler: @escaping (_ nickName: String) -> Void) -> UIAlertController {

        let alertTitle = nickName == nil ? "Для начала создайте ваш никнейм" : "Измените ваш никнейм"
        let alert = UIAlertController(title: alertTitle,
                                      message: "Длинна не более 8 символов",
                                      preferredStyle: .alert)

        alert.addTextField { textFiled in
            if nickName == nil {
                textFiled.placeholder = "инкогнито"
            } else {
                textFiled.text = nickName
            }
        }

        let actionTitle = nickName == nil ? "Создать" : "Изменить"
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            if let nickName = alert.textFields?.first?.text {
                completionHandler(nickName)
            }
        }
        action.isEnabled = false

        if let textField = alert.textFields?.first {
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                                   object: textField,
                                                   queue: .main) { _ in
                if let text = textField.text, 1...8 ~= text.count {
                    action.isEnabled = true
                } else {
                    action.isEnabled = false
                }
            }
        }
        alert.addAction(action)

        if nickName != nil {
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        }

        return alert
    }

    func createWarningResetData(completion: @escaping (_ successful: Bool) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Внимание!",
                                      message: "Это приведёт к первоначальным настройкам. Удалить все данные?",
                                      preferredStyle: .alert)
        let success = UIAlertAction(title: "Да", style: .default) { _ in
            completion(true)
        }
        let cansel = UIAlertAction(title: "Нет", style: .cancel)

        alert.addAction(success)
        alert.addAction(cansel)

        return alert
    }

    func createBackMainMenuAlert(completion: @escaping () -> Void) -> UIAlertController {
        let text = "Возврат на главный экран отменит текущую игру"
        let alert = UIAlertController(title: "Предупреждение", message: text, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Выйти", style: .default) { _ in
            completion()
        }
        let actionCansel = UIAlertAction(title: "Остаться", style: .default)
        alert.addAction(actionOK)
        alert.addAction(actionCansel)

        return alert
    }
}
