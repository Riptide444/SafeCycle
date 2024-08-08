//
//  HomeView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/23/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var searchManager = SearchManager()
    @ObservedObject var bluetoothManager: BluetoothManager
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var navigationManager: NavigationManager
    @Namespace var searchNamespace
//    @State var searchViewDisplayed: Bool = false
    @State var searchDisabled = true
    @State var eta: Eta?
    
    var body: some View {
        if !searchManager.isSearchDisplayed {
            ZStack(alignment: .bottom) {
                MapView(locationManager: locationManager, navigationManager: navigationManager)
                    .safeAreaInset(edge: .bottom) {
                        VStack {
                            SearchButtonView(searchPrompt: .constant(""), isDisabled: $searchDisabled)
                                .padding(.horizontal)
                                .tint(.primary)
                                .onTapGesture {
                                    searchDisabled = false
                                    withAnimation(.spring()) {
                                        searchManager.showSearchView()
                                    }
                                }
                                .matchedGeometryEffect(id: "search", in: searchNamespace)
                            if locationManager.destination != nil {
                                HStack(spacing: 10) {
                                    if let eta {
                                        Text(formatTime(eta: eta))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.secondary)
                                            .padding()
                                            .padding(2)
                                            .background(.thinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 25)
                                                    .strokeBorder(.tertiary.opacity(0.6), lineWidth: 1)
                                            }
                                    }
                                    Button(action: {
                                        if let location = locationManager.location, let route = navigationManager.route {
                                            navigationManager.getNextStepDistance(stepCoordinate: route.steps[1].polyline.points()[0].coordinate, location: location)
                                        }
                                        navigationManager.activeSession = true
                                        
                                    }, label: {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "location.north.line.fill")
                                            Text("Begin Route")
                                            Spacer()
                                        }
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .padding(.vertical)
                                        .buttonStyle(PlainButtonStyle())
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                    })
                                }
                                .padding(.top, 2)
                                .padding(.horizontal)
                            
                            }
                        }
                    }
            }
        } else {
            SearchView(isDisabled: $searchDisabled, searchManager: searchManager, locationManager: locationManager, searchNamespace: searchNamespace)
                .onDisappear {
                    self.searchDisabled = true
                    if let route = navigationManager.route {
                        self.eta = locationManager.getETA(route: route)
                    }
                }
                .onAppear {
                    bluetoothManager.sendMessage(bluetoothManager.message)
                }
        }
    }
}

func formatTime(eta: Eta) -> String {
    if eta.hours == 0 {
        return "\(String(format: "%.0f", eta.minutes)) min"
    } else {
        return "\(String(format: "%.0f", eta.hours)) hr \(String(format: "%.0f", eta.minutes)) min"
    }
}

#Preview {
    HomeView(bluetoothManager: BluetoothManager(), locationManager: LocationManager(), navigationManager: NavigationManager())
}
