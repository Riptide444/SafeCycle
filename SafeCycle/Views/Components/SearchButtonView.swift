//
//  SearchButtonView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/23/24.
//

import SwiftUI

struct SearchButtonView: View {
    @Binding var searchPrompt: String
    @Binding var isDisabled: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search Address", text: $searchPrompt)
                .disabled(isDisabled)
                .focused($isFocused)
                .frame(alignment: .leading)
            Spacer()
        }
        .foregroundStyle(.secondary)
        .font(.title3)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(.tertiary.opacity(0.6), lineWidth: 1)
        }
        .onAppear {
            if !isDisabled {
                isFocused.toggle()
            }
        }
    }
}

#Preview {
    SearchButtonView(searchPrompt: .constant(""), isDisabled: .constant(false))
}
