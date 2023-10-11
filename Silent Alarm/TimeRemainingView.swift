//
//  TimeRemainingView.swift
//  Silent Alarm
//
//  Created by Kennion Gubler on 10/10/23.
//

import SwiftUI

struct TimeRemainingView: View {
    @Binding var timeRemaining: TimeInterval

    var body: some View {
        VStack {
            Text("Time Remaining:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top)

            Text(timeFormatted(timeRemaining))
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }

    private func timeFormatted(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
