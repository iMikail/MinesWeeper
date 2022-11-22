//
//  Timer.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 22.11.22.
//

import Foundation

class GameTimer {
    
    private let timeDifficulty: Int
    
    var gameTime: String { getStringTime(gameSeconds) }
    private var gameSeconds: Int { timeDifficulty - timerTimeSeconds }
    
    var timerTime: ((_ time: String) -> ())?
    private var timerTimeSeconds: Int {
        didSet {
            DispatchQueue.main.async {
                
                self.timerTime?(self.getStringTime(self.timerTimeSeconds))
            }
        }
    }
    
    private var timer: DispatchSourceTimer?
    var isPlay: Bool {
        didSet {
            isPlay ? timer?.resume() : timer?.suspend()
        }
    }
    
    init(_ seconds: Int, isPlay: Bool = false) {
        self.timeDifficulty = seconds
        timerTimeSeconds = timeDifficulty
        self.isPlay = isPlay
        self.timer = DispatchSource.makeTimerSource(queue: .global())
        timer!.schedule(deadline: .now() + .seconds(1), repeating: 1)
        timer!.setEventHandler { [weak self] in
            self?.timerTimeSeconds -= 1
        }
    }
    
    // hh:mm:ss
    private func getStringTime(_ time: Int) -> String {
        let seconds = (time % 3600) % 60
        let minutes = (time % 3600) / 60
        let hours = time / 3600
        var timeString = ""
        if hours > 0 {
            timeString = String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else if minutes > 0 {
            timeString = String(format: "%0.2d:%0.2d", minutes, seconds)
        } else {
            timeString = String(format: "%0.2d", seconds)
        }
        return timeString
    }
    
    func reset() {
        isPlay = false
        timerTimeSeconds = timeDifficulty
    }
}
