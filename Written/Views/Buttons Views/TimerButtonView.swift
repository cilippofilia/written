//
//  TimerButtonView.swift
//  written
//
//  Created by Filippo Cilia on 12/12/2025.
//

import SwiftUI

struct TimerButtonView: View {
    @Environment(CountdownViewModel.self) var viewModel

    let timers: [Int] = [5, 300, 600, 900, 1200, 1500, 1800]
    
    var body: some View {
        GlassEffectContainer {
            Group {
                if !viewModel.timerActive {
                    timerMenuView
                } else {
                    stopButton
                }
            }
        }
    }

    private var timerMenuView: some View {
        Menu {
            ForEach(timers, id: \.self) { timer in
                Button {
                    viewModel.startTimer(duration: TimeInterval(timer))
                } label: {
                    Text(viewModel.formattedTime(for: timer))
                }
            }

            Divider()

            Text("How long for?")
        } label: {
            Image(systemName: "timer")
                .padding()
                .frame(height: 50)
                .foregroundStyle(.primary)
                .contentTransition(.symbolEffect(.replace))
        }
        .menuOrder(.priority)
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive())
    }

    private var stopButton: some View {
        Button(action: {
            viewModel.stopTimer()
        }) {
            Image(systemName: "stop.circle")
        }
        .padding()
        .frame(height: 50)
        .foregroundStyle(.primary)
        .contentTransition(.symbolEffect(.replace))
        .glassEffect(.regular.interactive())
    }
}

#Preview {
    TimerButtonView()
        .environment(CountdownViewModel())
}
