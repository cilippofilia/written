//
//  TestView.swift
//  written
//
//  Created by Filippo Cilia on 11/09/2025.
//

import SwiftUI

enum AnimationPhases {
    case typingSend
    case deletingSend
    case typingWritten
    case deletingWritten
}

struct TestView: View {
    @State var phase: AnimationPhases = .deletingSend

    @State var displayText: String = "Send"
    @State var currentStep: Int = 4
    @State var isPaused: Bool = false

    let sendText: String = "Send"
    let rittenText: String = "ritten"
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    let pauseDuration: TimeInterval = 1.5

    var imageName: String? {
        switch phase {
        case .typingSend, .deletingSend:
            return "paperplane"
        case .typingWritten, .deletingWritten:
            return "written-logo"
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            if let imageName = imageName {
                switch phase {
                case .typingSend, .deletingSend:
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing)
                        .transition(.opacity)
                case .typingWritten, .deletingWritten:
                    Image(imageName)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .transition(.opacity)
                }
            }
            Text(displayText)
                .animation(.easeInOut, value: displayText)
        }
        .onReceive(timer) { _ in
            guard !isPaused else { return }

            switch phase {
            case .deletingSend:
                if currentStep > 0 {
                    currentStep -= 1
                    displayText = String(sendText.prefix(currentStep))
                } else {
                    pauseAndContinue {
                        phase = .typingWritten
                        currentStep = 0
                    }
                }

            case .typingWritten:
                if currentStep < rittenText.count {
                    currentStep += 1
                    displayText = String(rittenText.prefix(currentStep))
                }
                if currentStep == rittenText.count {
                    pauseAndContinue {
                        phase = .deletingWritten
                        currentStep = rittenText.count
                    }
                }

            case .deletingWritten:
                if currentStep > 0 {
                    currentStep -= 1
                    displayText = String(rittenText.prefix(currentStep))
                }
                if currentStep == 0 {
                    pauseAndContinue {
                        phase = .typingSend
                        currentStep = 0
                    }
                }

            case .typingSend:
                if currentStep < sendText.count {
                    currentStep += 1
                    displayText = String(sendText.prefix(currentStep))
                }
                if currentStep == sendText.count {
                    pauseAndContinue {
                        phase = .deletingSend
                        currentStep = sendText.count
                    }
                }
            }
        }
        .onAppear {
            displayText = sendText
            currentStep = sendText.count
            phase = .deletingSend
        }
    }

    private func pauseAndContinue(_ completion: @escaping ActionVoid) {
        isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) {
            isPaused = false
            completion()
        }
    }
}

#Preview {
    TestView()
}
