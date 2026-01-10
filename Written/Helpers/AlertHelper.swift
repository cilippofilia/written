//
//  AlertHelper.swift
//  Written
//
//  Created by Filippo Cilia on 10/01/2026.
//

import Foundation

enum AlertType {
    case inputEmpty
    case lowCharacterCount
    case aiGeneration(title: String, message: String)
    case timeUp

    var title: String {
        switch self {
        case .inputEmpty, .lowCharacterCount:
            return "OOPS!"
        case .aiGeneration(let title, _):
            return title
        case .timeUp:
            return "Time is up!"
        }
    }

    var message: String {
        switch self {
        case .inputEmpty:
            return "Your input is empty.\nStart the timer, set it to the minimum and start typing away!"
        case .lowCharacterCount:
            return "Your input is too short. Try adding a few more words before sending."
        case .aiGeneration(_, let message):
            return message
        case .timeUp:
            return "Feel free to finish up your thoughts and then press Send!"
        }
    }

    var buttonText: String {
        switch self {
        case .inputEmpty, .lowCharacterCount:
            return "Dismiss"
        case .aiGeneration, .timeUp:
            return "Got it!"
        }
    }
}
