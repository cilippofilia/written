//
//  HistoryView.swift
//  Written
//
//  Created by Filippo Cilia on 28/01/2026.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var noEntries: Bool = false

    var body: some View {
        NavigationStack {
            if noEntries {
                emptyContentView
            } else {
                contentView
            }
        }
    }

    var contentView: some View {
        List {
            ForEach(1..<21, id: \.self) { i in
                NavigationLink(value: i) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prompt \(i)")
                            .bold()
                        Text("Description of prompt \(i)")
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .contentShape(.rect(cornerRadius: 12, style: .continuous))
                .listRowInsets(.init(top: 6, leading: 12, bottom: 0, trailing: 6))
                .listRowSeparator(.hidden)
            }
        }
        .navigationTitle(Text("History"))
//        .navigationDestination(for: Int.self) { promptNumber in
//            PromptDetailView(promptNumber: promptNumber)
//        }
        .listStyle(.plain)
    }

    var emptyContentView: some View {
        ContentUnavailableView(
            label: {
                Label("No history yet", systemImage: "book")
            },
            description: {
                Text("Seems there is nothing here yet. Go back and type your thoughts away!")
            },
            actions: {
                Button(action: {
                    dismiss()
                }) {
                    Label("Go back", systemImage: "arrow.left")
                }
                .buttonStyle(.borderedProminent)
            }
        )
    }
}

#Preview {
    HistoryView()
}
