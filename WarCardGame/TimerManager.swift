import Foundation
class TimerManager{
    
    private var timer: Timer?
    private var seconds: Int
    private var callback: () -> Void
    
    init(seconds: Int, callback: @escaping () -> Void) {
        self.seconds = seconds
        self.callback = callback
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(seconds), target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func tick() {
        callback()
    }
}

