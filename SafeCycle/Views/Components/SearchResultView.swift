//
//  SearchResultView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/23/24.
//

import SwiftUI

struct SearchResultView: View {
    let name: String
    let address: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.title3)
                .fontWeight(.medium)
            Text(address)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(.white.opacity(0.2))
        }
    }
}

#Preview {
    SearchResultView(name: "University of Maryland Campus", address: "1234 Lovelace Drive, Bethesda, MD")
}
