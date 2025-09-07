//
//  HomeView.swift
//  written
//
//  Created by Filippo Cilia on 03/09/2025.
//

import SwiftUI

public typealias ActionVoid = () -> Void

struct HomeView: View {
    @Namespace private var namespace
    @Namespace private var namespace2

    @State private var colorScheme: ColorScheme = .light
    @State private var showSettings = false

    @State var text: String = ""

    @State private var timerActive = false
    @State private var timerPaused = false
    @State private var timerCount = 0
    @State private var timer: Timer? = nil

    @State private var showTimers = false
    @State private var showingChatMenu = false
    @State private var didCopyPrompt = false

    let viewModel = HomeViewModel()

    // Initialize with saved theme preference if available
    init() {
        // Load saved color scheme preference
        let savedScheme = UserDefaults.standard.string(forKey: "colorScheme") ?? "light"
        _colorScheme = State(initialValue: savedScheme == "dark" ? .dark : .light)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 30)

                textfieldView

                Spacer()
                    .frame(height: 30)

                HStack {
                    settingsButtonView {
                        showSettings = true
                    }

                    sendButtonView {
                        showingChatMenu = true
                        // Calculate potential URL lengths
                        viewModel.calculateURLLenghts()
                    }
                    .animation(.spring, value: timerActive || timerPaused)
                    .popover(isPresented: $showingChatMenu) {
                        popoverSendContent()
                    }

                    Spacer()

                    GlassEffectContainer(spacing: 50) {
                        HStack {
                            if !timerActive {
                                Menu {
                                    Button("60") {
                                        viewModel.timeRemaining = 60
                                        if !timerActive {
                                            startTimer()
                                        }
                                    }
                                    Button("120") {
                                        viewModel.timeRemaining = 120
                                        if !timerActive {
                                            startTimer()
                                        }
                                    }
                                    Button("180") {
                                        viewModel.timeRemaining = 180
                                        if !timerActive {
                                            startTimer()
                                        }
                                    }
                                } label: {
                                    timerButtonImage
                                        .padding()
                                        .foregroundStyle(.primary)
                                        .glassEffect(.regular.interactive())
                                        .glassEffectID(2, in: namespace)
                                        .glassEffectTransition(.matchedGeometry(properties: .position, anchor: .leading))
                                }
                                .buttonStyle(.plain)
                            } else {
                                timerButtonImage
                                    .padding()
                                    .foregroundStyle(.primary)
                                    .glassEffect(.regular.interactive())
                                    .glassEffectID(2, in: namespace)
                                    .glassEffectTransition(.matchedGeometry(properties: .position, anchor: .leading))
                                    .onTapGesture {
                                        if !timerActive {
                                            startTimer()
                                        } else if timerPaused {
                                            resumeTimer()
                                        } else {
                                            pauseTimer()
                                        }
                                    }
                            }

                            if timerActive {
                                stopButtonView {
                                    stopTimer()
                                }
                                .glassEffectID(1, in: namespace)
                                .glassEffectTransition(.matchedGeometry)
                            }
                        }
                    }
                    .animation(.spring, value: timerActive || timerPaused)
                }
                .padding(.horizontal)
            }
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
            }
            .onAppear {
                viewModel.setRandomPlaceholderText()
            }
        }
    }
}

// MARK: Methods
extension HomeView {
    func startTimer() {
        timerActive = true
        timerPaused = false
        timerCount = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { _ in
            timerCount += 1
        }
    }

    func pauseTimer() {
        timer?.invalidate()
        timerPaused = true
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerActive = false
        timerPaused = false
        timerCount = 0
    }

    func resumeTimer() {
        timerPaused = false
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timerCount += 1
            print("Timer: \(timerCount)s")
        }
    }
}

// MARK: Subviews
extension HomeView {
    func settingsButtonView(
        _ action: @escaping ActionVoid
    ) -> some View {
        Image(systemName: "gear")
            .padding()
            .foregroundStyle(.primary)
            .glassEffect(.regular.interactive())
            .onTapGesture {
                action()
            }
    }

    func sendButtonView(
        _ action: @escaping ActionVoid
    ) -> some View {
        HStack {
            Image(systemName: "character.cursor.ibeam")
            Text("written")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(.white)
        .glassEffect(.regular.interactive().tint(.blue))
        .onTapGesture {
            action()
        }
    }

    func stopButtonView(
        _ action: @escaping ActionVoid
    ) -> some View {
        Image(systemName: "stop.circle")
            .padding()
            .foregroundStyle(.primary)
            .glassEffect(.regular.interactive())
            .onTapGesture {
                action()
            }
    }

    var timerButtonImage: Image {
        if !timerActive {
            Image(systemName: "timer")
        } else if timerPaused {
            Image(systemName: "play.circle")
        } else {
            Image(systemName: "pause.circle")
        }
    }

    var textfieldView: some View {
        TextField(
            "",
            text: $text,
            axis: .vertical
        )
        .overlay(alignment: .leading) {
            if text.isEmpty {
                Text(viewModel.placeholderText)
                    .foregroundStyle(.secondary)
                    .bold()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    func popoverSendContent() -> some View {
        if viewModel.isUrlTooLong {
            promptTooLongContent()
        } else if text.count < 5 { // TODO: change this to 350
            promptTooShortContent
        } else {
            aiModelsMenu()
        }
    }

    func copyPromptButtonView() -> some View {
        Button(action: {
            viewModel.copyPromptToClipboard()
            withAnimation {
                didCopyPrompt = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    didCopyPrompt = false
                }
            }
        }) {
            Label(didCopyPrompt ? "Copied!" : "Copy Prompt", systemImage: didCopyPrompt ? "checkmark" : "document.on.document")
                .padding()
                .glassEffect(.regular.interactive())
        }
        .animation(.spring, value: didCopyPrompt)
    }

    func promptTooLongContent() -> some View {
        VStack {
            Spacer()
            // View for long text (URL too long)
            Text("Hey, your entry is long. It'll break the URL. Instead, copy prompt by clicking below and paste into AI of your choice!")
                .padding()

            copyPromptButtonView()

            Spacer()
        }
    }

    var promptTooShortContent: some View {
        Text("Please free write for at minimum 5 minutes first. Then click this. Trust the process.")
    }

    func aiModelsMenu() -> some View {
        VStack {
            // View for normal text length
            Button(action: {
                showingChatMenu = false
                viewModel.openChatGPT()
            }) {
                Text("ChatGPT")
            }
            .buttonStyle(.plain)

            Button(action: {
                showingChatMenu = false
                viewModel.openClaude()
            }) {
                Text("Claude")
            }
            .buttonStyle(.plain)

            copyPromptButtonView()
        }
    }
}

#Preview {
    HomeView()
}
