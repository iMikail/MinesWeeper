//
//  GameDifficultyViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class GameDifficultyViewController: UIViewController {
    // MARK: - Variables
    var fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: DefaultOptions.minFieldSize,
                                                               row: DefaultOptions.minFieldSize),
                                          bombsCount: DefaultOptions.minBombsCount) {
        // check min/max size & bombs
        didSet {
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
    }

    // MARK: - Outlets
    @IBOutlet weak var easyOutlet: DifficultyButton!
    @IBOutlet weak var mediumOutlet: DifficultyButton!
    @IBOutlet weak var hardOutlet: DifficultyButton!
    @IBOutlet weak var yourChoiseOutlet: DifficultyButton!
    @IBOutlet weak var timerOutlet: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
