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
    @State var viewDone: Bool = false
    @StateObject var crashManager = CrashManager()
    @StateObject var locationManager = LocationManager()
    @StateObject var bluetoothManager = BluetoothManager()
    @StateObject var mqttManager = MQTTManager()
    @StateObject var navigationManager = NavigationManager()
    
    var body: some View {
        ZStack(alignment: .top) {
            if !crashManager.isCrashDetected {
                if welcomeToggle {
                    WelcomeView(locationManager: locationManager, mqttManager: mqttManager, welcomeToggle: $welcomeToggle)
                } else if !navigationManager.activeSession {
                    //            NavigationView()
                    HomeView(bluetoothManager: bluetoothManager, locationManager: locationManager, navigationManager: navigationManager)
                } else {
                    NavigationView(mqttManager: mqttManager, locationManager: locationManager, navigationManager: navigationManager)
                }
            } else {
                CrashView(crashManager: crashManager)
            }
            if mqttManager.carBack, !viewDone {
                VehicleAlertView(viewDone: $viewDone)
                    .transition(.slide)
            }
        }
        .onChange(of: viewDone) { oldValue, newValue in
            if !oldValue, newValue {
                mqttManager.carBack = false
                viewDone = false
            }
        }
    }

}

#Preview {
    ContentView()
}
