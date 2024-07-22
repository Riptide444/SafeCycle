//
//  MapTestView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/25/24.
//

import SwiftUI
import CoreLocationUI

struct MapTestView: View {
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        if let myLocation = locationManager.location {
            Text("Latitude: \(myLocation.latitude.formatted(.number.precision(.fractionLength(0)))), Longitude: \(myLocation.longitude.formatted(.number.precision(.fractionLength(0))))".uppercased())
        } else {
            LocationButton {
                locationManager.requestLocationPermission()
            }
            .labelStyle(.iconOnly)
            .foregroundStyle(.white)
            .cornerRadius(20)
        }
    }
}

#Preview {
    MapTestView()
}
