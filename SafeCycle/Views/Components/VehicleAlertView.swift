//
//  VehicleAlertView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/12/24.
//

import SwiftUI

struct VehicleAlertView: View {
    @State private var viewSize: CGSize = .zero
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    @Binding var viewDone: Bool
    var progressWidth: CGFloat {
        if viewSize != .zero, timer != nil {
            return CGFloat(progress*(viewSize.width))
        } else {
            return CGFloat(0.0)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                Text("Vehicle Detected Behind You")
            }
            Rectangle()
                .fill(.black.opacity(0.25))
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                viewSize.self = geometry.size
                            }
                    }
                }
                .overlay(alignment: .leading) {
                    Capsule()
                        .frame(width: progressWidth)
                }
                .clipShape(Capsule())
                .frame(height: 6)
                .padding(.top, 8)
        }
        .font(.title2)
        .foregroundStyle(.white)
        .fontDesign(.rounded)
        .fontWeight(.semibold)
        .padding()
        .background(.red, in: RoundedRectangle(cornerRadius: 25))
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(.white.opacity(0.4), lineWidth: 2)
        }
        .padding(.horizontal)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate() // Stop the timer if the view disappears
        }
    }
    
    func startTimer() {
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.progress < 1.0 {
                withAnimation {
                    self.progress += 0.01 // Update progress every 0.1 seconds (5 sec total)
                }
            } else {
                self.viewDone = true
                print(viewDone)
                self.timer?.invalidate() // Stop the timer when progress reaches 1.0
            }
        }
    }
}

#Preview {
    ZStack(alignment: .top) {
        MapView(locationManager: LocationManager(), navigationManager: NavigationManager())
        VehicleAlertView(viewDone: .constant(false))
    }
}
