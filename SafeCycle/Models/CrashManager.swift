//
//  CrashManager.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/12/24.
//

import CoreMotion

class CrashManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let threshold: Double = 9  // Example threshold value, adjust based on testing
    private var accCount = 0
    private var gyroCount = 0

    @Published var isCrashDetected = false

    init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    private func startMonitoring() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                if let data = data {
                    self?.handleAccelerometerData(data)
                }
            }
        }

        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                if let data = data {
                    self?.handleGyroData(data)
                }
            }
        }
    }

    private func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
    }

    private func handleAccelerometerData(_ data: CMAccelerometerData) {
        let acceleration = data.acceleration
        let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)

        if magnitude > threshold {
            DispatchQueue.main.async {
                self.isCrashDetected = true
            }
        }
    }

    private func handleGyroData(_ data: CMGyroData) {
        let rotationRate = data.rotationRate
        let magnitude = sqrt(rotationRate.x * rotationRate.x + rotationRate.y * rotationRate.y + rotationRate.z * rotationRate.z)

        if magnitude > threshold {
            DispatchQueue.main.async {
                self.isCrashDetected = true
            }
        }
    }
}
