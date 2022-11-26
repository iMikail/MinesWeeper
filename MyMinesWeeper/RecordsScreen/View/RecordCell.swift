//
//  RecordCell.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 26.11.22.
//

import UIKit

class RecordCell: UITableViewCell {
    
    var record: Record? {
        didSet {
            if let record = record {
                timeLable.text = record.timeString
                nickNameLable.text = record.nickName
                dateLable.text = record.date
            }
        }
    }
    
    @IBOutlet var timeLable: UILabel!
    @IBOutlet var nickNameLable: UILabel!
    @IBOutlet var dateLable: UILabel!  
}
