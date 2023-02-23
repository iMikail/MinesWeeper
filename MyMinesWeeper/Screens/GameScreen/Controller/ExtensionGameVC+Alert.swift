//
//  GameAlertControllers.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 2.11.22.
//

import UIKit

extension GameViewController {
    public func winnerAlertController() -> UIAlertController {
        var message = ""
        if let gameTimer = gameTimer {
            message = "Ваше время: \(gameTimer.gameTime)c"
        }
        let alert = UIAlertController(title: "Поздравляю вы выиграли!", message: message, preferredStyle: .alert)

        let recordsAction = UIAlertAction(title: "Рекорды", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segues.fromGameVCToRecordsVC.rawValue, sender: nil)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
        }

        alert.addAction(recordsAction)
        alert.addAction(menuAction)
        alert.addAction(restartAction)

        return alert
    }

    public func loserAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "Вы проиграли..", message: "", preferredStyle: .alert)

        let skipAction = UIAlertAction(title: "Открыть поле", style: .default) { [weak self] _ in
            self?.showAllField()
        }
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }

        alert.addAction(skipAction)
        alert.addAction(restartAction)
        alert.addAction(menuAction)

        return alert
    }

    public func pauseAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "Пауза", message: "", preferredStyle: .alert)

        let beginAction = UIAlertAction(title: "Продолжить", style: .cancel) { [weak self] action in
            self?.beginButtonAction(action)
        }

        alert.addAction(beginAction)

        return alert
    }
}
