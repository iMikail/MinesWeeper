//
//  MainScreenViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 20.10.22.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Variables
    private let userDefault = UserDefaults.standard
    private let greeting = "Приветствую тебя "
    private var nickName: String? {
        didSet {
            setGreeting()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var greetingLabel: UILabel!
    // Визуал кнопок в сториборде
    @IBOutlet weak var startGameOutlet: UIButton!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Меню"
        navigationItem.backButtonTitle = navigationItem.title
        setFirstOptions()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNickName()
    }

    // MARK: - Actions
    @IBAction func startGameAction(_ sender: Any) {
        if nickName == nil {
            createNickName()
        } else {
            performSegue(withIdentifier: Segues.fromMainVCToGameDifficultyVC.rawValue, sender: nil)
        }
    }

    @IBAction func optionsAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.fromMainVCToOptionsVC.rawValue, sender: nil)
    }

    // MARK: - Private functions
    private func createNickName() {
        let alertManager = AlertManager()
        let alert = alertManager.createNickNameAlert { [weak self] nickName in
            guard let self = self else { return }

            self.nickName = nickName
            self.userDefault.setValue(nickName, forKey: UserDefaultsKeys.currentNickName.rawValue)
        }
        present(alert, animated: true)
    }

    private func updateNickName() {
        nickName = userDefault.string(forKey: UserDefaultsKeys.currentNickName.rawValue)
    }

    private func setGreeting() {
        if let nickName = nickName {
            greetingLabel.text = greeting + nickName + "!"
        } else {
            greetingLabel.text = greeting + UserDefaultsKeys.defaultNickName.rawValue + "!"
        }
    }

    private func setFirstOptions() {
        let isNotFirstStart = userDefault.bool(forKey: UserDefaultsKeys.notFirstStartApp.rawValue)
        if !isNotFirstStart {
            userDefault.set(true, forKey: UserDefaultsKeys.timerOptions.rawValue)
            userDefault.set(true, forKey: UserDefaultsKeys.notFirstStartApp.rawValue)
        }
    }
}
