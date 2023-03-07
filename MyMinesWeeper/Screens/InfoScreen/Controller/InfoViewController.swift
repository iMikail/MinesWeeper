//
//  InfoViewController.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 7.03.23.
//

import UIKit

final class InfoViewController: UIViewController {

    @IBOutlet weak var cellImageOutlet: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cellImageOutlet.layer.borderWidth = 2
        cellImageOutlet.layer.borderColor = UIColor.black.cgColor
    }
}
