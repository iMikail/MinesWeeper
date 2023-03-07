//
//  GameViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Variables/Constants
    private let nickName = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentNickName.rawValue) ??
                            UserDefaultsKeys.defaultNickName.rawValue
    private let cellIdentifier = "fieldCell"
    private let alertManager = AlertManager()
    var minesWeeper: MinesWeeper!
    private var gameTimer: GameTimer?
    private var field: FieldArray { minesWeeper.fieldBuilder.field }

    private var isFlagMode = false
    private var flagCount = 0 {
        didSet {
            updateLabelText()
            if flagCount >= minesWeeper.fieldDifficulty.bombsCount {
                toggleFlagMode()
                flagButtonOutlet.isEnabled = false
            } else {
                flagButtonOutlet.isEnabled = true
            }
        }
    }
    private var defusedBombsCount = 0 {
        didSet {
            if defusedBombsCount == minesWeeper.fieldDifficulty.bombsCount {
                setupVictory()
            }
        }
    }

    private var isEndGame = false {
        didSet {
            pauseButtonOutlet.isEnabled = !isEndGame
            flagButtonOutlet.isEnabled = !isEndGame
            gameTimer?.reset()
        }
    }
    private var isPlay = false {
        didSet {
            let title = isPlay ? "Пауза" : "Продолжить"
            pauseButtonOutlet.setTitle(title, for: .normal)
            pauseImageView.isHidden = isPlay
            collectionView.isHidden = !isPlay
            updatePauseImage(isDefaultState: false)
            flagButtonOutlet.isEnabled = isPlay
            gameTimer?.isPlay = isPlay
        }
    }

    // MARK: - Views
    private lazy var pauseImageView: UIImageView = UIImageView(frame: collectionView.frame)

    // MARK: - Outlets
    @IBOutlet weak var timerImageOutlet: UIImageView!
    @IBOutlet weak var timeLabelOutlet: UILabel!

    @IBOutlet weak var infoStackOutlet: UIStackView!
    @IBOutlet weak var flagButtonOutlet: UIButton!
    @IBOutlet weak var bombCountOutlet: UILabel!
    @IBOutlet weak var fieldSizeImageOutlet: UIImageView!
    @IBOutlet weak var fieldSizeOutlet: UILabel!
    @IBOutlet weak var freeCellsImageOutlet: UIImageView!
    @IBOutlet weak var freeCellsOutlet: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var pauseButtonOutlet: UIButton!
    @IBOutlet weak var descriptionButtonOutlet: UIButton!
    @IBOutlet weak var restartButtonOutlet: UIButton!

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInfoStackViews()
        setupTimer()
        setupLabelText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPauseImageView()
        setupBorderFor(collectionView, size: 1, color: .darkGray)
        collectionView.layer.cornerRadius = 5
    }

    // MARK: - Actions
    @IBAction func beginButtonAction(_ sender: Any) {
        isPlay = !isPlay
    }

    @IBAction func flagButtonAction(_ sender: UIButton) {
        toggleFlagMode()
    }

    @IBAction func restartButtonAction(_ sender: Any) {
        minesWeeper.resetGame()
        isEndGame = false
        isPlay = false
        isFlagMode = false
        flagCount = 0
        setupTimerStack()
        updatePauseImage(isDefaultState: true)
        pauseButtonOutlet.setTitle("Начать", for: .normal)
        collectionView.reloadData()
    }

    @IBAction func descriptionButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: Segues.fromGameVCToInfoVC.rawValue, sender: nil)
    }

    @IBAction func menuButtonAction(_ sender: UIButton) {
        let alert = alertManager.createBackMainMenuAlert { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        present(alert, animated: true)
    }

    // MARK: - Functions
    private func toggleFlagMode() {
        isFlagMode = !isFlagMode
        if isFlagMode {
            setupBorderFor(flagButtonOutlet, size: 2, color: .red)
        } else {
            setupBorderFor(flagButtonOutlet, size: 1, color: .gray)
        }
    }

    private func switchCellFlag(forSection section: Int, inRow row: Int, isIncrease: Bool) {
        minesWeeper.fieldBuilder.field[section][row].toggleFlag()
        flagCount = isIncrease ? flagCount + 1 : flagCount - 1

        if field[section][row].isMine {
            defusedBombsCount = isIncrease ? defusedBombsCount + 1 : defusedBombsCount - 1
        }
    }

    private func showAllField() {
        minesWeeper.fieldBuilder.deEnableAllCells()
        collectionView.reloadData()
    }

    private func saveTimeRecord() {
        guard let time = gameTimer?.gameSeconds,
              let type = minesWeeper.fieldDifficulty.recordType else { return }

        let record = Record(time: time, nickName: nickName, type: type)
        RecordsManager.shared.addRecord(record)
    }

    // MARK: Setup functions
    private func setupVictory() {
        saveTimeRecord()
        present(winnerAlertController(), animated: true)
        isEndGame = true
        showAllField()
    }

    private func setupGameOver(alertMessage: String) {
        present(loserAlertController(message: alertMessage), animated: true)
        isEndGame = true
    }

    private func setupLabelText() {
        setupTimerStack()
        fieldSizeOutlet.text = "\(minesWeeper.fieldDifficulty.fieldSize.row)x" +
        "\(minesWeeper.fieldDifficulty.fieldSize.section)"
        bombCountOutlet.text = "x\(minesWeeper.fieldDifficulty.bombsCount)"
        freeCellsOutlet.text = "x\(String(minesWeeper.fieldDifficulty.cellsCount))"
        minesWeeper.notSelectedCeelsCount = { [weak self] count in
            self?.freeCellsOutlet.text = "x\(String(describing: count))"
        }
    }

    private func updateLabelText() {
        bombCountOutlet.text = "x\(minesWeeper.fieldDifficulty.bombsCount - flagCount)"
    }

    private func setupPauseImageView() {
        pauseImageView.isUserInteractionEnabled = true
        pauseImageView.backgroundColor = .clear
        updatePauseImage(isDefaultState: true)
        view.addSubview(pauseImageView)
    }

    private func updatePauseImage(isDefaultState: Bool) {
        let image = isDefaultState ? ImageName.startWarningImage.rawValue : ImageName.pauseImage.rawValue
        pauseImageView.image = UIImage(named: image)
    }

    private func setupBorderFor(_ view: UIView, size: CGFloat, color: UIColor) {
        view.layer.borderWidth = size
        view.layer.borderColor = color.cgColor
    }

    private func setupTimer() {
        if let time = minesWeeper.fieldDifficulty.time {
            gameTimer = GameTimer(time)
            gameTimer?.delegate = self
        }
    }

    private func setupTimerStack() {
        guard let gameTimer = gameTimer else {
            timeLabelOutlet.isHidden = true
            timerImageOutlet.image = UIImage(named: ImageName.timerOffImage.rawValue)
            return
        }

        timerImageOutlet.image = UIImage(named: ImageName.timerOnImage.rawValue)
        timeLabelOutlet.text = gameTimer.originTime
        gameTimer.timerTime = { [weak self] time in
            self?.timeLabelOutlet.text = time
        }
    }

    private func setupInfoStackViews() {
        setupBorderFor(flagButtonOutlet, size: 1, color: .gray)
        flagButtonOutlet.layer.cornerRadius = flagButtonOutlet.bounds.height / 2

        setupBorderFor(freeCellsImageOutlet, size: 2, color: .black)
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

        switch isFlagMode {
        case true:
            if !field[section][row].isFlag {
                switchCellFlag(forSection: section, inRow: row, isIncrease: true)
            }
        case false:
            if field[section][row].isFlag {
                switchCellFlag(forSection: section, inRow: row, isIncrease: false)
            } else {
                minesWeeper.selectedCells(indexPath: indexPath)
                if field[section][row].isMine {
                    setupGameOver(alertMessage: "Подорвался на бомбе")
                } else {
                    if minesWeeper.checkWin() {
                        setupVictory()
                    }
                }
            }
        }
        collectionView.reloadData()
    }
}

// MARK: - GameTimerDelegate
extension GameViewController: GameTimerDelegate {
    func timeIsOver() {
        setupGameOver(alertMessage: "Вышло время")
    }
}
