//
//  TurnButtonView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI

struct TurnButtonView: View {
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        HStack {
            Button(action: {
                if navigationManager.upcomingDirection == .left {
                    navigationManager.upcomingDirection = nil
                } else {
                    navigationManager.upcomingDirection = .left
                }

            }, label: {
                if navigationManager.upcomingDirection != .left {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .padding(25)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                } else {
                    Image(systemName: "arrowshape.turn.up.left.fill")
                        .padding(25)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }
            })
            .foregroundStyle(.primary)
            
            Button(action: {
                if navigationManager.upcomingDirection == .stop {
                    navigationManager.upcomingDirection = nil
                } else {
                    navigationManager.upcomingDirection = .stop
                }
            }, label: {
                if navigationManager.upcomingDirection != .stop {
                    HStack {
                        Spacer()
                        Text("STOP")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .padding(.horizontal, 8)
                } else {
                    HStack {
                        Spacer()
                        Text("STOP")
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    .padding(.vertical, 20)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 35))
                    .padding(.horizontal, 8)
                    
                }
            })
            .foregroundStyle(.primary)
            Button(action: {
                if navigationManager.upcomingDirection == .right {
                    navigationManager.upcomingDirection = nil
                } else {
                    navigationManager.upcomingDirection = .right
                }
            }, label: {
                if navigationManager.upcomingDirection != .right {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .padding(25)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                } else {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                        .padding(25)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 35))
                }
            })
            .foregroundStyle(.primary)
        }
        .font(.largeTitle)
    }
}

#Preview {
    TurnButtonView(navigationManager: NavigationManager())
}
