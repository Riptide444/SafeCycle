//
//  WelcomeView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/23/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var welcomeToggle: Bool
    
    var body: some View {
        Text("Welcome")
            .padding()
            .font(.title2)
            .fontWeight(.medium)
            .onAppear {
                locationManager.requestLocationPermission()
            }
        Spacer()
        if (locationManager.location == nil) {
            LocationButton(.currentLocation) {
                locationManager.requestLocationPermission()
            }
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .foregroundStyle(.white)
                .symbolVariant(.fill)
                .labelStyle(.titleAndIcon)
        } else {
            Text("Latitude: \(locationManager.location!.latitude.formatted(.number.precision(.fractionLength(0)))), Longitude: \(locationManager.location!.longitude.formatted(.number.precision(.fractionLength(0))))".uppercased())
        }
        Button(action: {
            withAnimation {
                welcomeToggle = false
            }
            
        }, label: {
            Text("Connect Your SafeCycle")
                .fontWeight(.semibold)
                .font(.title2)
                .padding(.vertical)
                .padding(.horizontal, 35)
                .foregroundStyle(.background)
                .background(.foreground)
                .clipShape(RoundedRectangle(cornerRadius: 25))
        })
        .tint(.primary)
        
    }
}

#Preview {
    WelcomeView(locationManager: LocationManager(), welcomeToggle: .constant(true))
}
