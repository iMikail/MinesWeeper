//
//  Records.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 26.11.22.
//
import Foundation

enum RecordType: Int, CaseIterable {
    case easy
    case medium
    case hard
}

class Record {
    let type: RecordType
    let time: Int
    var timeString: String { GameTimer.getStringTime(time) }
    let nickName: String
    let date: String

    init(time: Int, nickName: String, type: RecordType) {
        self.type = type
        self.time = time
        self.nickName = nickName
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        self.date = dateFormatter.string(from: Date())
    }

}
