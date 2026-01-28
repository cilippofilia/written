//
//  PromptDetailView.swift
//  Written
//
//  Created by Filippo Cilia on 28/01/2026.
//

import SwiftUI

struct PromptDetailView: View {
    let promptNumber: Int

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Prompt \(promptNumber)")
                    .font(.title)
                    .bold()
                    .padding(.bottom)

                Text(loremIpsum)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    PromptDetailView(promptNumber: 10)
}
