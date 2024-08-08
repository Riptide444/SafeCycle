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
    @StateObject var bluetoothManager = BluetoothManager()
    @StateObject var mqttManager = MQTTManager()
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        if welcomeToggle {
            WelcomeView(locationManager: locationManager, mqttManager: mqttManager, welcomeToggle: $welcomeToggle)
        } else if !navigationManager.activeSession {
//            NavigationView()
            HomeView(bluetoothManager: bluetoothManager, locationManager: locationManager, navigationManager: navigationManager)
        } else {
            NavigationView(mqttManager: mqttManager, locationManager: locationManager, navigationManager: navigationManager)
        }
    }

}

#Preview {
    ContentView()
}
