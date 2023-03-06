//
//  GameDifficultyViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class GameDifficultyViewController: UIViewController {
    // MARK: - Variables
    private var fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: DefaultOptions.minFieldSize,
                                                               row: DefaultOptions.minFieldSize),
                                                  bombsCount: DefaultOptions.minBombsCount) {
        didSet {
            resizingIfNeeded()
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var easyOutlet: DifficultyButton!
    @IBOutlet weak var mediumOutlet: DifficultyButton!
    @IBOutlet weak var hardOutlet: DifficultyButton!
    @IBOutlet weak var yourChoiseOutlet: DifficultyButton!
    @IBOutlet weak var timerOutlet: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        timerOutlet.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.timerOptions.rawValue)
        setViews()
    }

    // MARK: - Actions
    @IBAction func easyAction(_ sender: Any) {
        performSegueWithDifficulty(.easy)
    }

    @IBAction func mediumAction(_ sender: Any) {
        performSegueWithDifficulty(.medium)
    }

    @IBAction func hardAction(_ sender: Any) {
        performSegueWithDifficulty(.hard)
    }

    @IBAction func yourChoiseAction(_ sender: Any) {
        performSegueWithDifficulty(.yourChoise)
    }

    @IBAction func timerSwitchAction(_ sender: UISwitch) {
        if !sender.isOn {
            fieldDifficulty.time = nil
        }
        configureButtons()
    }

    // MARK: - Functions
    private func performSegueWithDifficulty(_ difficulty: Difficulty) {
        self.fieldDifficulty = difficulty.fieldDifficulty
        if difficulty == .yourChoise {
            present(difficultyAlertController(timerIsEnabled: timerOutlet.isOn), animated: true)
        } else {
            performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
        }
    }

    // preSet options for game field(size & bombs)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameViewController else { return }
        if !timerOutlet.isOn {
            fieldDifficulty.time = nil
        }
        gameVC.minesWeeper = MinesWeeper(fieldDifficulty: fieldDifficulty)
    }

    private func resizingIfNeeded() {
        print(" ->old options:\n\(FieldDifficulty.description(forFieldDifficulty: fieldDifficulty))")
        fieldDifficulty.fieldSize.section = resizeValue(fieldDifficulty.fieldSize.section,
                                                        minValue: DefaultOptions.minFieldSize,
                                                        maxValue: DefaultOptions.maxFieldSize)
        fieldDifficulty.fieldSize.row = resizeValue(fieldDifficulty.fieldSize.row,
                                                        minValue: DefaultOptions.minFieldSize,
                                                        maxValue: DefaultOptions.maxFieldSize)
        fieldDifficulty.bombsCount = resizeValue(fieldDifficulty.bombsCount,
                                                 minValue: DefaultOptions.minBombsCount,
                                                 maxValue: fieldDifficulty.maxBombsCount)
        if let time = fieldDifficulty.time {
            fieldDifficulty.time = resizeValue(time,
                                               minValue: DefaultOptions.minTime,
                                               maxValue: DefaultOptions.maxTime)
        }
        print(" ->new options:\n\(FieldDifficulty.description(forFieldDifficulty: fieldDifficulty))")
    }

    private func resizeValue(_ value: Int, minValue: Int, maxValue: Int) -> Int {
        return min(max(value, minValue), maxValue)
    }

    private func setViews() {
        navigationItem.title = "Выбор уровня"
        navigationItem.backButtonTitle = navigationController?.viewControllers.last?.title

        configureButtons()
    }

    private func configureButtons() {
        easyOutlet.configureFromDifficulty(.easy, timerIsEnable: timerOutlet.isOn)
        mediumOutlet.configureFromDifficulty(.medium, timerIsEnable: timerOutlet.isOn)
        hardOutlet.configureFromDifficulty(.hard, timerIsEnable: timerOutlet.isOn)
        yourChoiseOutlet.configureFromDifficulty(.yourChoise, timerIsEnable: timerOutlet.isOn)
    }

    // MARK: - AlertController functions for yourChoise
    private func difficultyAlertController(timerIsEnabled: Bool) -> UIAlertController {
        let message = "Укажите параметры (неверные данные будут заменены на ближайшие подходящие)"
        let alert = UIAlertController(title: "Ваш выбор", message: message, preferredStyle: .alert)
        let beginAction = UIAlertAction(title: "Играть", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
        }
        let canselAction = UIAlertAction(title: "Отмена", style: .cancel)
        beginAction.isEnabled = false

        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, text: "Ширина поля:")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, placeholder: "15-100", isEnable: true)
        }

        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, text: "Высота поля:")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, placeholder: "15-100", isEnable: true)
        }

        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, text: "Количество бомб:")
        }
        alert.addTextField { [weak self] textField in
            self?.configureTextField(textField, placeholder: ">10", isEnable: true)
        }

        if timerIsEnabled {
            alert.addTextField { [weak self] textField in
                self?.configureTextField(textField, text: "Таймер(в секундах):")
            }
            alert.addTextField { [weak self] textField in
                self?.configureTextField(textField, placeholder: "60-3600(1мин - 1час)", isEnable: true)
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

    private func configureTextField(_ textField: UITextField, text: String? = nil,
                                    placeholder: String? = nil, isEnable: Bool = false) {
        textField.text = text
        textField.placeholder = placeholder
        textField.isEnabled = isEnable
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
}
