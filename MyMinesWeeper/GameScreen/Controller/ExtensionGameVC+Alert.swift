//
//  GameAlertControllers.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 2.11.22.
//

import Foundation
import UIKit

extension GameViewController {
    
    public func winnerAlertController() -> UIAlertController {
        let ac = UIAlertController(title: "Поздравляю вы выиграли!", message: "", preferredStyle: .alert)
        
        let recordsAction = UIAlertAction(title: "Рекорды", style: .default) { [weak self] action in
            self?.performSegue(withIdentifier: Segues.fromGameVCToRecordsVC.rawValue, sender: nil)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] action in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
            self?.beginButtonAction(action)
        }
        
        ac.addAction(recordsAction)
        ac.addAction(menuAction)
        ac.addAction(restartAction)
        
        return ac
    }
    
    public func loserAlertController() -> UIAlertController {
        let ac = UIAlertController(title: "Вы проиграли..", message: "", preferredStyle: .alert)
        
        let skipAction = UIAlertAction(title: "Скрыть", style: .default)
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
            self?.beginButtonAction(action)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] action in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        
        ac.addAction(skipAction)
        ac.addAction(restartAction)
        ac.addAction(menuAction)
        
        return ac
    }
    
    public func pauseAlertController() -> UIAlertController {
        let ac = UIAlertController(title: "Пауза", message: "", preferredStyle: .alert)

        let beginAction = UIAlertAction(title: "Продолжить", style: .cancel) { [weak self] action in
            self?.beginButtonAction(action)
        }

        ac.addAction(beginAction)
        
        return ac
    }
 
}
