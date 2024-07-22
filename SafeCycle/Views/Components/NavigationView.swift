//
//  NavigationView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            MapView(locationManager: locationManager, navigationManager: navigationManager)
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        TurnButtonView(navigationManager: navigationManager)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        DirectionBarView(navigationManager: navigationManager)
                            .padding([.horizontal, .bottom])
                    }
                    .padding(.bottom)
                }
            .ignoresSafeArea()
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            navigationManager.resetRoute()
                            navigationManager.activeSession = false
                        }
                    }, label: {
                            Image(systemName: "xmark")
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(.circle)
                        
                    })
                    Spacer()
                    Button(action: {
                        // Identify nearby vehicles and display simply
                    }, label: {
                            Image(systemName: "wave.3.right")
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(.circle)
                    })
                }
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.primary)
                .font(.title)
                Spacer()
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationView(locationManager: LocationManager(), navigationManager: NavigationManager())
}
