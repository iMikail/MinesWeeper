//
//  ViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Variables
    private let cellIdentifier = "fieldCell"
    var minesWeeper: MinesWeeper!
    var gameTimer: GameTimer?
    private var field: FieldArray { minesWeeper.fieldBuilder.field }
    
    private var isEndGame = false {
        didSet {
            pauseButtonOutlet.isEnabled = !isEndGame
            gameTimer?.reset()
        }
    }
    
    private var isPlay = false {
        didSet {
            isPlay ? pauseButtonOutlet.setTitle("Пауза", for: .normal) : pauseButtonOutlet.setTitle("Продолжить", for: .normal)
            pauseImageView.isHidden = isPlay
            gameTimer?.isPlay = isPlay
        }
    }
    private var pauseImageView: UIImageView!
        
    // MARK: - Outlets
    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    @IBOutlet weak var restartButtonOutlet: UIButton!
    
    @IBOutlet weak var fieldSizeOutlet: UILabel!
    @IBOutlet weak var bombCountOutlet: UILabel!
    @IBOutlet weak var freeCellsOutlet: UILabel!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Сапёр"
        
        collectionView.backgroundColor = .systemGray5
        setBorderFor(collectionView)
        setPauseImageView()
        if let time = minesWeeper.fieldDifficulty.time {
            gameTimer = GameTimer(time)
        }
        setLabelText()
    }
    
    // MARK: - Actions
    @IBAction func beginButtonAction(_ sender: Any) {
        isPlay = !isPlay
    }
    
    @IBAction func restartButtonAction(_ sender: Any) {
        minesWeeper.resetGame()
        isEndGame = false
        isPlay = false
        setTimerLabel()
        pauseButtonOutlet.setTitle("Начать", for: .normal)
        collectionView.reloadData()
    }
    
    // MARK: - Functions
    internal func showAllField() {
        minesWeeper.fieldBuilder.deEnableAllCells()
        collectionView.reloadData()
    }
    
    private func setLabelText() {
        setTimerLabel()
        fieldSizeOutlet.text = "Размер поля: \(minesWeeper.fieldDifficulty.fieldSize.row)x\(minesWeeper.fieldDifficulty.fieldSize.section)"
        bombCountOutlet.text = "Количество бомб: \(minesWeeper.fieldDifficulty.bombsCount)"
        freeCellsOutlet.text = "Клеток осталось: \(String(minesWeeper.fieldDifficulty.cellsCount))"
        minesWeeper.notSelectedCeelsCount = { [weak self] count in
            self?.freeCellsOutlet.text = "Клеток осталось: \(String(describing: count))"
        }
    }
    
    private func setPauseImageView() {
        pauseImageView = UIImageView(frame: collectionView.frame)
        pauseImageView.isUserInteractionEnabled = true
        setBorderFor(pauseImageView)
        pauseImageView.backgroundColor = collectionView.backgroundColor
        pauseImageView.image = UIImage(systemName: "questionmark.square.dashed")
        view.addSubview(pauseImageView)
    }
    
    private func setBorderFor(_ view: UIView) {
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    private func setTimerLabel() {
        guard let gameTimer = gameTimer else {
            timeLabelOutlet.isHidden = true
            print("GameTimer = nil")
            return
        }
        timeLabelOutlet.text = gameTimer.originTime
        gameTimer.timerTime = { [weak self] time in
            self?.timeLabelOutlet.text = time
        }
    }
}

// MARK: - Extensions
extension GameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        minesWeeper.fieldDifficulty.fieldSize.section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        minesWeeper.fieldDifficulty.fieldSize.row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FieldViewCell else { return UICollectionViewCell() }
        
        cell.fieldCell = field[indexPath.section][indexPath.row]

        return cell
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let i = indexPath.section
        let j = indexPath.row
        minesWeeper.selectedCells(indexPath: indexPath)
        
        if field[i][j].isMine {
            if let cell = collectionView.cellForItem(at: indexPath) as? FieldViewCell {
                cell.fieldCell = field[i][j]
                present(loserAlertController(), animated: true)
                isEndGame = true
            }
        } else {
            collectionView.reloadData()
            if minesWeeper.checkWin() {
                present(winnerAlertController(), animated: true)
                isEndGame = true
                showAllField()
            }
        }
    }
}
