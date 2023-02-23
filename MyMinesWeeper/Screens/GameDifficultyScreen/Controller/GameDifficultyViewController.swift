//
//  GameDifficultyViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class GameDifficultyViewController: UIViewController {
    // MARK: - Variables
    var fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: Constants.minFieldSize,
                                                               row: Constants.minFieldSize),
                                          bombsCount: Constants.minBombsCount) {
        // check min/max size & bombs
        didSet {
            print("section old: \(fieldDifficulty.fieldSize.section)")
            print("row old: \(fieldDifficulty.fieldSize.row)")
            print("bomb old: \(fieldDifficulty.bombsCount)")
            fieldDifficulty.fieldSize.section = resizeValue(fieldDifficulty.fieldSize.section,
                                                            minValue: Constants.minFieldSize,
                                                            maxValue: Constants.maxFieldSize)
            fieldDifficulty.fieldSize.row = resizeValue(fieldDifficulty.fieldSize.row,
                                                            minValue: Constants.minFieldSize,
                                                            maxValue: Constants.maxFieldSize)
            fieldDifficulty.bombsCount = resizeValue(fieldDifficulty.bombsCount,
                                                     minValue: Constants.minBombsCount,
                                                     maxValue: fieldDifficulty.maxBombsCount)
            print("section new: \(fieldDifficulty.fieldSize.section)")
            print("row new: \(fieldDifficulty.fieldSize.row)")
            print("new: \(fieldDifficulty.bombsCount)")
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var easyOutlet: DifficultyButton!
    @IBOutlet weak var mediumOutlet: DifficultyButton!
    @IBOutlet weak var hardOutlet: DifficultyButton!
    @IBOutlet weak var yourChoiseOutlet: DifficultyButton!

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

    // MARK: - Functions
    private func performSegueWithDifficulty(_ difficulty: Difficulty) {
        self.fieldDifficulty = difficulty.fieldDifficulty
        if difficulty == .yourChoise {
            difficultyAlertController()
        } else {
            performSegue(withIdentifier: Segues.fromGameDifficultyVCToGameVC.rawValue, sender: nil)
        }
    }

    // preSet options for game field(size & bombs)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameVC = segue.destination as? GameViewController else { return }

        gameVC.minesWeeper = MinesWeeper(fieldDifficulty: fieldDifficulty)
    }

    private func resizeValue(_ value: Int, minValue: Int, maxValue: Int) -> Int {
        return min(max(value, minValue), maxValue)
    }

    private func setViews() {
        navigationItem.title = "Выбор уровня"
        navigationItem.backButtonTitle = navigationController?.viewControllers.last?.title

        easyOutlet.configureFromDifficulty(.easy)
        mediumOutlet.configureFromDifficulty(.medium)
        hardOutlet.configureFromDifficulty(.hard)
        yourChoiseOutlet.configureFromDifficulty(.yourChoise)
    }
}
