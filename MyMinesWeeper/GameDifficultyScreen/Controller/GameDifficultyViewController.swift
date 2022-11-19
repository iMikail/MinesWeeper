//
//  GameDifficultyViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 9.11.22.
//

import UIKit

class GameDifficultyViewController: UIViewController {

    // MARK: - Variables
    // TODO: - Упростить!!!! обрезка мин макс размеров и бомб
    var fieldDifficulty = FieldDifficulty(fieldSize: FieldSize(section: Constants.minFieldSize,
                                                               row: Constants.minFieldSize),
                                          bombsCount: Constants.minBombsCount) {
        // Check parametres min/max size & bombs
        didSet {
            print("section old: \(fieldDifficulty.fieldSize.section)")
            print("row old: \(fieldDifficulty.fieldSize.row)")
            fieldDifficulty.fieldSize.section = fieldDifficulty.fieldSize.section > Constants.minFieldSize ? fieldDifficulty.fieldSize.section : Constants.minFieldSize
            if fieldDifficulty.fieldSize.section > Constants.maxFieldSize {
                fieldDifficulty.fieldSize.section = Constants.maxFieldSize
            }
            
            fieldDifficulty.fieldSize.row = fieldDifficulty.fieldSize.row > Constants.minFieldSize ? fieldDifficulty.fieldSize.row : Constants.minFieldSize
            if fieldDifficulty.fieldSize.row > Constants.maxFieldSize {
                fieldDifficulty.fieldSize.row = Constants.maxFieldSize
            }
            print("section new: \(fieldDifficulty.fieldSize.section)")
            print("row new: \(fieldDifficulty.fieldSize.row)")
            print("bomb old: \(fieldDifficulty.bombsCount)")
            fieldDifficulty.bombsCount = fieldDifficulty.bombsCount > fieldDifficulty.maxBombsCount ? fieldDifficulty.maxBombsCount : fieldDifficulty.bombsCount
            if fieldDifficulty.bombsCount < Constants.minBombsCount {
                fieldDifficulty.bombsCount = Constants.minBombsCount
            }
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
    // perform segue with choosed difficulty
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

    private func setViews() {
        navigationItem.title = "Выбор уровня"
        navigationItem.backButtonTitle = navigationController?.viewControllers.last?.title
        
        easyOutlet.configureFromDifficulty(.easy)
        mediumOutlet.configureFromDifficulty(.medium)
        hardOutlet.configureFromDifficulty(.hard)
        yourChoiseOutlet.configureFromDifficulty(.yourChoise)
    }

}
