//
//  MapView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/22/24.
//

import SwiftUI
import MapKit


struct MapView: View {
    @ObservedObject var locationManager: LocationManager
    @ObservedObject var navigationManager: NavigationManager
    @State private var selectedDestination: MKMapItem?
    
    var body: some View {
            Map(selection: $selectedDestination) {
                if let destination = locationManager.destination, let location = locationManager.location {
                    if !navigationManager.activeSession {
                        Marker("Your Location", coordinate: location)
                            .tint(.green)
                    } else {
                        Annotation("", coordinate: location) {
                            ZStack {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.blue)
                                    .font(.largeTitle)
                                    .frame(width: 30, height: 30)
                                Image(systemName: "location")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .frame(width: 30, height: 30)
                            }
                            .rotationEffect(Angle(degrees: locationManager.direction - 45.0))
                        }
                    }
                    Marker(destination.name, coordinate: destination.coordinate)
                } else if let location = locationManager.location {
                    if !navigationManager.activeSession {
                        Annotation("Current Location", coordinate: location) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 10, height: 10)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 12, height: 12)
                            }
                        }
                    }
                }
                
                // Show the route if it is available
                if let route = locationManager.route {
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .onAppear {
                if locationManager.destination != nil {
                    getDirections()
                }
            }
            .onChange(of: locationManager.location) { oldValue, newValue in
                if let oldValue, let newValue, let route = navigationManager.route {
                    let stepCoordinate = route.steps[navigationManager.step + 1].polyline.points()[0].coordinate
                    navigationManager.getNextStepDistance(stepCoordinate: stepCoordinate, location: newValue)
                    
                    locationManager.calculateDirection(oldCoordinate: oldValue, newCoordinate: newValue)
                    
                    navigationManager.checkStepState(stepCoordinate: stepCoordinate,
                                                     nextStepCoordinate: route.steps[navigationManager.step + 2].polyline.points()[0].coordinate,
                                                     oldLocation: oldValue, newLocation: newValue)
                    
                    navigationManager.nearStep(stepCoordinate: stepCoordinate, location: newValue)
                }
        }
            .overlay(alignment: .top) {
                GeometryReader { proxy in
                    VariableBlurView(maxBlurRadius: 3)
                        .frame(height: proxy.safeAreaInsets.top)
                        .ignoresSafeArea()
                }
            }
        
    }
    
    func getDirections() {
        locationManager.route = nil

        // Check if there is a selected result
        guard let destination = locationManager.destination else { return }
        guard let location = locationManager.location else { return }

        // Create and configure the request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate))
        request.transportType = .walking
        
        // Set to avoid highways
        request.requestsAlternateRoutes = true
        request.highwayPreference = .avoid

        // Get the directions based on the request
        Task {
            let directions = MKDirections(request: request)

            let response = try? await directions.calculate()
            locationManager.route = response?.routes.first
            navigationManager.route = locationManager.route
        }
    }
}

#Preview {
    MapView(locationManager: LocationManager(), navigationManager: NavigationManager())
}

