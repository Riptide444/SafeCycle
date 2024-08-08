//
//  NavigationView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI
import Foundation

struct NavigationView: View {
    @ObservedObject var mqttManager: MQTTManager
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            MapView(locationManager: locationManager, navigationManager: navigationManager)
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        ZStack {
                            Text("Near next step?")
                                .fontWeight(.semibold)
                            +
                            Text(navigationManager.nearNextStep ? " Yes" : " No")
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom, 8)
                        TurnButtonView(navigationManager: navigationManager)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .onChange(of: navigationManager.upcomingDirection, initial: false) {_, newValue in
                                
                            }
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
                    if locationManager.speed != 0.0 {
                        Text("\(round(locationManager.speed)) mph")
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .font(.title2)
                            .padding()
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        Spacer()
                    }
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
    NavigationView(mqttManager: MQTTManager(), locationManager: LocationManager(), navigationManager: NavigationManager())
}
