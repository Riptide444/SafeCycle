//
//  NavigationManager.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/30/24.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

enum Direction {
    case right, left, stop
}

class NavigationManager: ObservableObject {
    @Published var route: MKRoute?
    @Published var upcomingDirection: Direction?
    @Published var step: Int = 0
    @Published var distanceToNextStep: Double = 0.0
    @Published var lastStep: Bool = false
    @Published var nearNextStep: Bool = false
    @Published var activeSession: Bool = false
    
    func checkStepState(stepCoordinate: CLLocationCoordinate2D, nextStepCoordinate: CLLocationCoordinate2D, oldLocation: CLLocationCoordinate2D, newLocation: CLLocationCoordinate2D) {
        if distanceBetween(coord1: oldLocation, coord2: stepCoordinate) < distanceBetween(coord1: newLocation, coord2: stepCoordinate) && distanceBetween(coord1: newLocation, coord2: nextStepCoordinate) < distanceBetween(coord1: oldLocation, coord2: nextStepCoordinate) {
            // Approaching next step
            if step + 1 < route!.steps.count - 1 {
                nearNextStep = false
                step += 1
            } else {
                nearNextStep = false
                lastStep = true
            }
            
        }
    }
    
    func resetRoute() {
        upcomingDirection = nil
        step = 0
        distanceToNextStep = 0.0
        lastStep = false
        nearNextStep = false
        activeSession = false
    }
    
    func getNextStepDistance(stepCoordinate: CLLocationCoordinate2D, location: CLLocationCoordinate2D) {
        distanceToNextStep = distanceBetween(coord1: stepCoordinate, coord2: location) / 0.0003048
        print(distanceToNextStep)
    }
    
    func nearStep(stepCoordinate: CLLocationCoordinate2D, location: CLLocationCoordinate2D) {
        if distanceBetween(coord1: stepCoordinate, coord2: location) < 0.04572 {
            // Within 150 ft of next step
            nearNextStep = true
            if upcomingDirection == nil, let route {
                if route.steps[step].instructions.lowercased().contains("left") {
                    upcomingDirection = .left
                } else if route.steps[step].instructions.lowercased().contains("right") {
                    upcomingDirection = .right
                }
            }
        }
    }
    
    func getStepIcons(steps: [MKRoute.Step]) -> [String] {
        var symbols = [String]()
        
        for step in steps {
            if step.instructions.lowercased().contains("left") {
                symbols.append("arrow.turn.up.left")
            } else if step.instructions.lowercased().contains("right") {
                symbols.append("arrow.turn.up.right")
            } else if step.instructions.lowercased().contains("merge") {
                symbols.append("arrow.triangle.merge")
            } else {
                symbols.append("bicycle")
            }
        }
        
        return symbols
    }
}
