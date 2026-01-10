//
//  CountDownViewModel.swift
//  Written
//
//  Created by Filippo Cilia on 08/01/2026.
//

import SwiftUI

@Observable
@MainActor
final class CountdownViewModel {
    var endTime: Date?
    var timerActive = false
    var timerPaused = false
    var timerExpired = false

    private var expirationCheckTask: Task<Void, Never>?

    func startTimer(duration: TimeInterval) {
        withAnimation(.smooth) {
            endTime = Date.now.addingTimeInterval(duration)
            timerActive = true
            timerPaused = false
            timerExpired = false

            startExpirationCheck()
        }
    }

    // UNUSED: Not referenced in the current UI; consider removing if not needed.
    func pauseTimer() {
        withAnimation(.smooth) {
            timerPaused = true
            expirationCheckTask?.cancel()
        }
    }

    // UNUSED: Not referenced in the current UI; consider removing if not needed.
    func resumeTimer() {
        withAnimation(.smooth) {
            timerPaused = false
            startExpirationCheck()
        }
    }

    func stopTimer() {
        withAnimation(.smooth) {
            timerActive = false
            timerPaused = false
            endTime = nil
            expirationCheckTask?.cancel()
        }
    }

    func timeRemaining(at date: Date) -> TimeInterval {
        guard let endTime else { return 0 }
        return endTime.timeIntervalSince(date)
    }

    func formattedTime(for timer: Int) -> String {
        let minutes = timer / 60
        let seconds = timer % 60
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(minutesString):\(secondsString)"
    }

    private func startExpirationCheck() {
        expirationCheckTask?.cancel()
        expirationCheckTask = Task {
            while !Task.isCancelled && timerActive && !timerPaused {
                let remaining = timeRemaining(at: .now)
                if remaining <= 0 {
                    timerExpired = true
                    stopTimer()
                    break
                }
                try? await Task.sleep(for: .milliseconds(100))
            }
        }
    }
}
