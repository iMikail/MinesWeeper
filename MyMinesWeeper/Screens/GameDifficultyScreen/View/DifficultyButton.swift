//
//  DifficultyButton.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 10.11.22.
//

import UIKit

class DifficultyButton: UIButton {

     func configureFromDifficulty(_ difficulty: Difficulty) {
        if var configuration = configuration?.updated(for: self) {

            configuration.background.backgroundColor = .darkGray

            configuration.attributedTitle = AttributedString(difficulty.rawValue)
            configuration.attributedTitle?.font = .boldSystemFont(ofSize: 21)
            configuration.attributedSubtitle = AttributedString(
                "\(difficulty.fieldDifficulty.fieldSize.row)x" +
                "\(difficulty.fieldDifficulty.fieldSize.section), " +
                "\(difficulty.fieldDifficulty.bombsCount)")
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
