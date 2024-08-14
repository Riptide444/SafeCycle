//
//  DirectionBarView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI

struct DirectionBarView: View {
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        if let route = navigationManager.route {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: navigationManager.getStepIcons(steps: route.steps)[navigationManager.step])
                    Text("\((round(navigationManager.distanceToNextStep / 10) * 10).formatted(.number.precision(.fractionLength(0)))) ft")
                        .fontDesign(.rounded)
                    Spacer()
                    Image(systemName: "chevron.up.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                }
                .font(.title)
                .fontWeight(.semibold)
                Text(route.steps[navigationManager.step].instructions)
                    .font(.title2)
            }
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 35))
            .overlay {
                RoundedRectangle(cornerRadius: 35)
                    .strokeBorder(.foreground.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

#Preview {
    DirectionBarView(navigationManager: NavigationManager())
        .previewLayout(.sizeThatFits)
}
