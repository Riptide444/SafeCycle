import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Double {
    var degreesToRadians: Double { self * .pi / 180 }
    var radiansToDegrees: Double { self * 180 / .pi }
}

struct Eta {
    let hours: Double
    let minutes: Double
}

func distanceBetween(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
    let dLat = (coord2.latitude - coord1.latitude).degreesToRadians
    let dLong = (coord2.longitude - coord1.longitude).degreesToRadians
    
    let oLatRad = coord1.latitude.degreesToRadians
    let nLatRad = coord2.latitude.degreesToRadians
    
    let earthRadiusKm: Double = 6371
    
    let a = sin(dLat/2) * sin(dLat/2) +
    sin(dLong/2) * sin(dLong/2) * cos(oLatRad) * cos(nLatRad)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return earthRadiusKm * c
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var degrees: Double = 0
    @Published var direction: Double = 0
    @Published var speed: Double = 0
    @Published var location: CLLocationCoordinate2D?
    @Published var destination: SearchResult?
    @Published var route: MKRoute?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func updateDestination(newDestination: SearchResult?) {
        destination = newDestination
    }
    
    func requestLocationPermission() {
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        print("request")
    }
    
    func calculateDirection(oldCoordinate: CLLocationCoordinate2D, newCoordinate: CLLocationCoordinate2D) {
        let startLat = oldCoordinate.latitude.degreesToRadians
        let startLon = oldCoordinate.longitude.degreesToRadians
        let endLat = newCoordinate.latitude.degreesToRadians
        let endLon = newCoordinate.longitude.degreesToRadians
        
        let deltaLon = endLon - startLon
        
        let y = sin(deltaLon) * cos(endLat)
        let x = cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(deltaLon)
        
        let initialBearing = atan2(y, x).radiansToDegrees
        direction = (initialBearing + 360).truncatingRemainder(dividingBy: 360)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        degrees = newHeading.trueHeading
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            location = lastLocation.coordinate
            speed = lastLocation.speed < 0 ? 0 : lastLocation.speed * 3.6 * 0.6213711922  // Convert to km/h
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getETA(route: MKRoute) -> Eta {
        let etaRaw: Double = route.distance * 0.0006213712 / 9.5
        return Eta(hours: floor(etaRaw), minutes: (etaRaw - floor(etaRaw)) * 60.0)
    }
}
