//
//  CrashView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/12/24.
//

import SwiftUI

struct CrashView: View {
    @ObservedObject var crashManager: CrashManager
    @State private var viewSize: CGSize = .zero
    @State private var progress: Double = 0.0
    @State private var timer: Timer? = nil
    var progressWidth: CGFloat {
        if viewSize != .zero, timer != nil {
            return CGFloat(36.0 + progress*(viewSize.width-52))
        } else {
            return CGFloat(36.0)
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                Text("Crash Detected")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Calling Emergency Contacts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .opacity(0.8)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.red.opacity(0.4))
                        .frame(height: 50)
                        .background {
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        viewSize.self = geometry.size
                                    }
                            }
                        }
                    Capsule()
                        .fill(.red)
                        .frame(height: 36)
                        .frame(width: progressWidth)
                        .padding(.horizontal, 8)
                    Text(progress < 1 ? "\((round(5-(progress*5))).formatted(.number.precision(.fractionLength(0))))" : "Calling...")
                        .contentTransition(.numericText(value: progress))
                        .padding(.leading, 19)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                Spacer()
                Button {
                    crashManager.isCrashDetected = false
                    timer?.invalidate()
                } label: {
                    Text("Cancel")
                        .padding()
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 90)
                        .background(.red, in: RoundedRectangle(cornerRadius: 25))
                }

            }
            .foregroundStyle(.white)
            .fontDesign(.rounded)
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate() // Stop the timer if the view disappears
            }
        }
    }
    
    func startTimer() {
        progress = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if self.progress < 1.0 {
                withAnimation {
                    self.progress += 0.02 // Update progress every 0.1 seconds (5 sec total)
                }
            } else {
                self.timer?.invalidate() // Stop the timer when progress reaches 1.0
            }
        }
    }

}

#Preview {
    CrashView(crashManager: CrashManager())
}
