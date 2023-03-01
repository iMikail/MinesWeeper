//
//  AlertManager.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 1.03.23.
//

import UIKit

final class AlertManager {
    func createNickNameAlert(_ completionHandler: @escaping (_ nickName: String) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Для начала создайте ваш никнейм",
                                      message: "Длинна не более 8 символов",
                                      preferredStyle: .alert)

        alert.addTextField { textFiled in
            textFiled.placeholder = "инкогнито"
        }

        let action = UIAlertAction(title: "Продолжить", style: .default) { _ in
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

        return alert
    }
}
