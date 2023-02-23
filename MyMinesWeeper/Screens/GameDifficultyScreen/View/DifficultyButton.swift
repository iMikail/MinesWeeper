//
//  DifficultyButton.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 10.11.22.
//

import UIKit

class DifficultyButton: UIButton {
    func configureFromDifficulty(_ difficulty: Difficulty, timerIsEnable: Bool) {
        if var configuration = configuration?.updated(for: self) {
            let options = difficulty.fieldDifficulty

            configuration.background.backgroundColor = .darkGray

            configuration.attributedTitle = AttributedString(difficulty.rawValue)
            configuration.attributedTitle?.font = .boldSystemFont(ofSize: 21)
            let size = "\(options.fieldSize.row)x\(options.fieldSize.section)"
            let bombCount = "\(options.bombsCount) бомб"
            var timeString = "Без таймера"
            if timerIsEnable {
                if let time = options.time {
                    timeString = "\(time / 60) минут"
                }
            }
            configuration.attributedSubtitle = AttributedString("\(size) ,\(bombCount) ,\(timeString)")

            configuration.attributedSubtitle?.font = .systemFont(ofSize: 17)
            configuration.attributedSubtitle?.foregroundColor = .lightGray

            switch difficulty {
            case .easy:
                configuration.attributedTitle?.foregroundColor = .systemGreen
            case .medium:
                configuration.attributedTitle?.foregroundColor = .systemOrange
            case .hard:
                configuration.attributedTitle?.foregroundColor = .systemRed
            case .yourChoise:
                configuration.attributedTitle?.foregroundColor = .white
                configuration.attributedSubtitle = nil
            }

            configuration.titleAlignment = .center

            configuration.background.strokeColor = .black
            configuration.background.cornerRadius = 20.0
            configuration.background.strokeWidth = 2.0

            self.configuration = configuration

        }

        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
    }
}
