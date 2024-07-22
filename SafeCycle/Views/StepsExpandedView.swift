//
//  StepsExpandedView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/1/24.
//

import SwiftUI

//struct StepsExpandedView: View {
//    @ObservedObject var navigationManager: NavigationManager
//    
//    var body: some View {
//        if let route = navigationManager.route {
//            VStack(alignment: .leading) {
//                HStack {
//                    Image(systemName: navigationManager.getStepIcons(steps: route.steps)[navigationManager.step])
//                    Text("\((round(navigationManager.distanceToNextStep / 10) * 10).formatted(.number.precision(.fractionLength(0)))) ft")
//                        .fontDesign(.rounded)
//                    Spacer()
//                    Image(systemName: "chevron.up.circle.fill")
//                        .symbolRenderingMode(.hierarchical)
//                        .foregroundStyle(.secondary)
//                }
//                .font(.title)
//                .fontWeight(.semibold)
//                Text(route.steps[navigationManager.step].instructions)
//                    .font(.title2)
//                ForEach(route.steps) { step in
//                    
//                }
//            }
//            .padding()
//            .background(.thinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 35))
//        }
//    }
//}
//
//#Preview {
//    StepsExpandedView(navigationManager: NavigationManager())
//}
