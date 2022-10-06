//
//  MainScreenViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 20.10.22.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Меню"
        navigationItem.backButtonTitle = navigationItem.title
        
    }
    
    @IBAction func startGameAction(_ sender: Any) {
        performSegue(withIdentifier: Segues.fromMainVCToGameDifficultyVC.rawValue, sender: nil)
    }
    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
