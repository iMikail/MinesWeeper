//
//  GameViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Variables
    private let nickName = UserDefaults.standard.string(forKey: DefaultOptions.currentNickName) ?? "Незнакомец"
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
            if isPlay {
                pauseButtonOutlet.setTitle("Пауза", for: .normal)
            } else {
                pauseButtonOutlet.setTitle("Продолжить", for: .normal)
            }
            pauseImageView.isHidden = isPlay
            gameTimer?.isPlay = isPlay
        }
    }
    private lazy var pauseImageView: UIImageView = UIImageView(frame: collectionView.frame)

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
        setupTimer()
        setupLabelText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPauseImageView()
        setBorderFor(collectionView)
        collectionView.isHidden = false
    }

    // MARK: - Actions
    @IBAction func beginButtonAction(_ sender: Any) {
        isPlay = !isPlay
    }

    @IBAction func restartButtonAction(_ sender: Any) {
        minesWeeper.resetGame()
        isEndGame = false
        isPlay = false
        setupTimerLabel()
        pauseButtonOutlet.setTitle("Начать", for: .normal)
        collectionView.reloadData()
    }

    // MARK: - Functions
    func showAllField() {
        minesWeeper.fieldBuilder.deEnableAllCells()
        collectionView.reloadData()
    }

    private func setupLabelText() {
        setupTimerLabel()
        fieldSizeOutlet.text = "Размер поля: \(minesWeeper.fieldDifficulty.fieldSize.row)x" +
        "\(minesWeeper.fieldDifficulty.fieldSize.section)"
        bombCountOutlet.text = "Количество бомб: \(minesWeeper.fieldDifficulty.bombsCount)"
        freeCellsOutlet.text = "Клеток осталось: \(String(minesWeeper.fieldDifficulty.cellsCount))"
        minesWeeper.notSelectedCeelsCount = { [weak self] count in
            self?.freeCellsOutlet.text = "Клеток осталось: \(String(describing: count))"
        }
    }

    private func setupPauseImageView() {
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

    // MARK: timer/records functions
    private func setupTimer() {
        if let time = minesWeeper.fieldDifficulty.time {
            gameTimer = GameTimer(time)
            gameTimer?.delegate = self
        }
    }

    private func setupTimerLabel() {
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

    private func saveTimeRecord() {
        guard let time = gameTimer?.gameSeconds,
              let type = minesWeeper.fieldDifficulty.recordType else { return }

        let record = Record(time: time, nickName: nickName, type: type)
        RecordsManager.shared.addRecord(record)
    }

    // MARK: AlertController functions
    private func winnerAlertController() -> UIAlertController {
        var message = ""
        if let gameTimer = gameTimer {
            message = "Ваше время: \(gameTimer.gameTime)c"
        }
        let alert = UIAlertController(title: "Поздравляю \(nickName) вы выиграли!",
                                      message: message,
                                      preferredStyle: .alert)

        let recordsAction = UIAlertAction(title: "Рекорды", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: Segues.fromGameVCToRecordsVC.rawValue, sender: nil)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
        }

        alert.addAction(recordsAction)
        alert.addAction(menuAction)
        alert.addAction(restartAction)

        return alert
    }

    private func loserAlertController(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "К сожалению \(nickName) вы проиграли.",
                                      message: message,
                                      preferredStyle: .alert)

        let skipAction = UIAlertAction(title: "Открыть поле", style: .default) { [weak self] _ in
            self?.showAllField()
        }
        let restartAction = UIAlertAction(title: "Заново", style: .default) { [weak self] action in
            self?.restartButtonAction(action)
        }
        let menuAction = UIAlertAction(title: "Меню", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }

        alert.addAction(skipAction)
        alert.addAction(restartAction)
        alert.addAction(menuAction)

        return alert
    }

    private func pauseAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "Пауза", message: "", preferredStyle: .alert)

        let beginAction = UIAlertAction(title: "Продолжить", style: .cancel) { [weak self] action in
            self?.beginButtonAction(action)
        }

        alert.addAction(beginAction)

        return alert
    }
}

// MARK: - Extensions UICollectionViewDataSource
extension GameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        minesWeeper.fieldDifficulty.fieldSize.section
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        minesWeeper.fieldDifficulty.fieldSize.row
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier, for: indexPath) as? FieldViewCell else {
            return UICollectionViewCell()
        }

        cell.fieldCell = field[indexPath.section][indexPath.row]

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let section = indexPath.section
        let row = indexPath.row
        minesWeeper.selectedCells(indexPath: indexPath)

        if field[section][row].isMine {
            if let cell = collectionView.cellForItem(at: indexPath) as? FieldViewCell {
                cell.fieldCell = field[section][row]
                present(loserAlertController(message: "Подорвался на бомбе"), animated: true)
                isEndGame = true
            }
        } else {
            collectionView.reloadData()
            if minesWeeper.checkWin() {
                saveTimeRecord()
                present(winnerAlertController(), animated: true)
                isEndGame = true
                showAllField()

            }
        }
    }
}

// MARK: - GameTimerDelegate
extension GameViewController: GameTimerDelegate {
    func timeIsOver() {
        present(loserAlertController(message: "Вышло время"), animated: true)
        isEndGame = true
    }
}
