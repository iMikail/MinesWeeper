//
//  ViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 6.10.22.
//

import UIKit

class GameViewController: UIViewController {

    // MARK: - Variables
    let cellIdentifier = "fieldCell"
    var minesWeeper: MinesWeeper!
    private var field: FieldArray { minesWeeper.fieldBuilder.field }
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var beginButtonOutlet: UIButton!
    @IBOutlet weak var restartButtonOutlet: UIButton!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.layer.borderWidth = 2.0
        collectionView.layer.borderColor = UIColor.systemOrange.cgColor
        
        
        title = "Сапёр"
        
       // collectionView.isHidden = true
        
        
    }

    // MARK: - Actions
    @IBAction func beginButtonAction(_ sender: Any) {
        //collectionView.isHidden = false
        
        //test
        showAllField()

    }
    
    @IBAction func restartButtonAction(_ sender: Any) {
        minesWeeper.resetGame()
        
        collectionView.reloadData()
      //  collectionView.isHidden = true
    }
    
    // MARK: - Functions
    private func showAllField() {
        minesWeeper.fieldBuilder.deEnableAllCells()
        collectionView.reloadData()
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

        let i = indexPath.section
        let j = indexPath.row
        
        cell.setCellView()
        
        if !field[i][j].isEnable {
            cell.reloadView(fieldCell: field[i][j])
        }

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
                showAllField()
                //TODO: don't work red background
                cell.reloadViewForBomb(fieldCell: field[i][j])
                present(loserAlertController(), animated: true)
            }
        } else {
            collectionView.reloadData()
            if minesWeeper.checkWin() {
                present(winnerAlertController(), animated: true)
            }
        }
        
        //test
        print("tap")
        print(indexPath)
        print(field[indexPath.section][indexPath.row])
    }
    
    
}
