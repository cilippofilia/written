//
//  HomeViewModel.swift
//  written
//
//  Created by Filippo Cilia on 03/09/2025.
//

import SwiftUI
import UniformTypeIdentifiers

@Observable
public class HomeViewModel {
    var placeholderText: String = ""
    var timer: Timer? = nil
    var timeRemaining: TimeInterval = 0

    let placeholderOptions: [String] = [
        "Begin writing",
        "Pick a thought and go",
        "Start typing",
        "What's on your mind",
        "Just start",
        "Type your first thought",
        "Start with one sentence",
        "Just say it"
    ]

    let promptOptions: [String] = [
        reflectivePrompt,
        insightfulPrompt,
        actionableSuggestionPrompt,
        validatingPrompt,
        challengingPrompt
    ]
}

// MARK: Timer methods
extension HomeViewModel {
    func formattedTime(for timer: Int) -> String {
        let minutes = timer / 60
        let seconds = timer % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var formattedTimeLeft: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: Entries methods
extension HomeViewModel {
    func copyPromptToClipboard(prompt: String, text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let fullText = prompt + "\n\n" + trimmedText

        UIPasteboard.general
            .setValue(fullText, forPasteboardType: UTType.plainText.identifier)
    }

    func setRandomPlaceholderText() {
        let text = placeholderOptions.randomElement() ?? "Begin writing"
        placeholderText = text + "..."
    }
}
