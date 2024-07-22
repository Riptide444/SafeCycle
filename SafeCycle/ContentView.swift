//
//  ContentView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var welcomeToggle: Bool = true
    @StateObject var locationManager = LocationManager()
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        if welcomeToggle {
            WelcomeView(locationManager: locationManager, welcomeToggle: $welcomeToggle)
        } else if !navigationManager.activeSession {
//            NavigationView()
            HomeView(locationManager: locationManager, navigationManager: navigationManager)
        } else {
            NavigationView(locationManager: locationManager, navigationManager: navigationManager)
        }
    }

}

#Preview {
    ContentView()
}
