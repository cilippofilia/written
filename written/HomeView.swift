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
                textfieldView

                Spacer()

                HStack {
                    sendButton {
                        print("Sending to AI model...")
                    }

                    Spacer()

                    GlassEffectContainer(spacing: 50) {
                        HStack {
                            if timerActive || timerPaused {
                                stopButton {
                                    timer?.invalidate()
                                    timer = nil
                                    timerActive = false
                                    timerPaused = false
                                    timerCount = 0
                                }
                                .glassEffectID(1, in: namespace)
                            }
                            timerButton {
                                if !timerActive {
                                    timerActive = true
                                    timerPaused = false
                                    timerCount = 0
                                    timer?.invalidate()
                                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                        timerCount += 1
                                        print("Timer: \(timerCount)s")
                                    }
                                } else if timerActive && !timerPaused {
                                    timer?.invalidate()
                                    timerPaused = true
                                } else if timerActive && timerPaused {
                                    timerPaused = false
                                    timer?.invalidate()
                                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                        timerCount += 1
                                        print("Timer: \(timerCount)s")
                                    }
                                }
                            }
                            .glassEffectID(2, in: namespace)
                        }
                    }
                    .animation(.spring, value: timerActive || timerPaused)

                    settingsButton {
                        showSettings = true
                    }
                    .glassEffectID(3, in: namespace2)
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

extension HomeView {
    func settingsButton(
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

    func sendButton(
        _ action: @escaping ActionVoid
    ) -> some View {
        HStack {
            Image(systemName: "paperplane")
            Text("Send")
        }
        .padding()
        .foregroundStyle(.white)
        .glassEffect(.regular.interactive().tint(.blue))
        .onTapGesture {
            action()
        }
    }

    func stopButton(
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

    func timerButton(
        _ action: @escaping ActionVoid
    ) -> some View {
        timerButtonImage
            .padding()
            .foregroundStyle(.primary)
            .glassEffect(.regular.interactive())
            .onTapGesture {
                action()
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
}

#Preview {
    HomeView()
}
