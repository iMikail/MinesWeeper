//
//  Timer.swift
//  MyMinesWeeper
//
//  Created by Misha Volkov on 22.11.22.
//

import Foundation

class GameTimer {
    
    let timeDifficulty: Int
    var originTime: String { GameTimer.getStringTime(timeDifficulty) }
    
    var gameTime: String { GameTimer.getStringTime(gameSeconds) }
    private var gameSeconds: Int { timeDifficulty - timerTimeSeconds }
    
    var timerTime: ((_ time: String) -> ())?
    private var timerTimeSeconds: Int {
        didSet {
            timerTime?(GameTimer.getStringTime(timerTimeSeconds))
        }
    }
    
    private var timer: DispatchSourceTimer
    private var state: State = .suspended
    var isPlay: Bool {
        didSet {
            isPlay ? resume() : suspend()
        }
    }

    init(_ seconds: Int, isPlay: Bool = false) {
        self.timeDifficulty = seconds
        timerTimeSeconds = timeDifficulty + 1
        self.isPlay = isPlay
        timer = DispatchSource.makeTimerSource(flags: .strict)
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                self?.timerTimeSeconds -= 1
            }
        }
    }
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
    }
    
    // hh:mm:ss
    static func getStringTime(_ time: Int) -> String {
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
        timerTime = nil
        timerTimeSeconds = timeDifficulty + 1
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
    
    private enum State {
        case suspended
        case resumed
    }
}
