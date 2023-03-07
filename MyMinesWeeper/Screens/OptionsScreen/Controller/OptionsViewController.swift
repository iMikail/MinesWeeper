//
//  OptionsViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 2.03.23.
//

import UIKit

final class OptionsViewController: UIViewController {
    // MARK: - Variables/Constants
    private let userDefaults = UserDefaults.standard
    private let alertManager = AlertManager()

    // MARK: - Outlets
    @IBOutlet weak var enableSoundOutlet: UIButton!
    @IBOutlet weak var timerStackOutlet: UIStackView!
    @IBOutlet weak var switchTimerOutlet: UISwitch!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Настройки"
        navigationItem.backButtonTitle = navigationItem.title
        updateTimerStackView()
        updateTimerSwitchState()
    }

    // MARK: - Actions
    @IBAction func changeNickAction(_ sender: UIButton) {
        let oldNickName = userDefaults.string(forKey: UserDefaultsKeys.currentNickName.rawValue)
        let alert = alertManager.createNickNameAlert(nickName: oldNickName) { [weak self] nickName in
            guard let self = self else { return }

            self.userDefaults.setValue(nickName, forKey: UserDefaultsKeys.currentNickName.rawValue)
        }
        present(alert, animated: true)
    }

    @IBAction func enableSoundAction(_ sender: UIButton) {
    }

    @IBAction func switchTimerAction(_ sender: UISwitch) {
        userDefaults.set(switchTimerOutlet.isOn, forKey: UserDefaultsKeys.timerOptions.rawValue)
    }

    @IBAction func resetAllDataAction(_ sender: UIButton) {
        let warningAlert = alertManager.createWarningResetData { [weak self] successful in
            if successful {
                guard let self = self else { return }

                self.removeAllData()
            }
        }
        present(warningAlert, animated: true)
    }

    // MARK: - Functions
    private func updateTimerStackView() {
        timerStackOutlet.layer.cornerRadius = 10
        timerStackOutlet.layer.borderColor = UIColor.systemIndigo.cgColor
        timerStackOutlet.layer.borderWidth = 1
    }

    private func updateTimerSwitchState() {
        switchTimerOutlet.isOn = userDefaults.bool(forKey: UserDefaultsKeys.timerOptions.rawValue)
    }

    private func removeAllData() {
        userDefaults.set(nil, forKey: UserDefaultsKeys.currentNickName.rawValue)
        userDefaults.set(false, forKey: UserDefaultsKeys.notFirstStartApp.rawValue)
        userDefaults.set(true, forKey: UserDefaultsKeys.timerOptions.rawValue)
        updateTimerSwitchState()
        RecordsManager.shared.resetAllRecords()
    }
}
