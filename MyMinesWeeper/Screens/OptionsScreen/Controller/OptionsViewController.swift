//
//  OptionsViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 2.03.23.
//

import UIKit

final class OptionsViewController: UIViewController {
    // MARK: - Variables/Constants
    private let userDefault = UserDefaults.standard
    private let alertManager = AlertManager()

    // MARK: - Outlets
    @IBOutlet weak var enableSoundOutlet: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Настройки"
        navigationItem.backButtonTitle = navigationItem.title
    }

    // MARK: - Actions
    @IBAction func changeNickAction(_ sender: UIButton) {
        let oldNickName = userDefault.string(forKey: DefaultOptions.currentNickName)
        let alert = alertManager.createNickNameAlert(nickName: oldNickName) { [weak self] nickName in
            guard let self = self else { return }

            self.userDefault.setValue(nickName, forKey: DefaultOptions.currentNickName)
        }
        present(alert, animated: true)
    }

    @IBAction func enableSoundAction(_ sender: UIButton) {
    }

    @IBAction func resetAllDataAction(_ sender: UIButton) {
        let warningAlert = alertManager.createWarningResetData { [weak self] successful in
            if successful {
                self?.userDefault.set(nil, forKey: DefaultOptions.currentNickName)
                RecordsManager.shared.resetAllRecords()
            }
        }
        present(warningAlert, animated: true)
    }
}
