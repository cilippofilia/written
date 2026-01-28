//
//  HistoryView.swift
//  Written
//
//  Created by Filippo Cilia on 28/01/2026.
//

import SwiftUI

struct HistoryView: View {

    var body: some View {
        NavigationStack {
            List {
                ForEach(1..<21, id: \.self) { i in
                    Button {
                        print("Tapped prompt \(i)")
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Prompt \(i)")
                                    .bold()
                                Text("Description of prompt \(i)")
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.forward")
                                .foregroundStyle(.tertiary)
                                .imageScale(.small)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 12, style: .continuous))
                        .contentShape(.rect(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(.init(top: 12, leading: 12, bottom: 0, trailing: 12))
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle(Text("History"))
            .listStyle(.plain)
        }
    }
}

#Preview {
    HistoryView()
}
