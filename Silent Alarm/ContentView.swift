import SwiftUI

struct ContentView: View {
    @State private var selectedMinutes = 15
    @State private var isRunning = false
    @State private var timeRemaining: TimeInterval = 0
    @State private var showBlinkingScreen = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Color(red: 21/255, green: 41/255, blue: 50/255) // Background color
                .edgesIgnoringSafeArea(.all)

            if !showBlinkingScreen {
                VStack {
                    if !isRunning { // Show "Set Silent Alarm" only if not running
                        Text("Set Silent Alarm")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }

                    if !isRunning {
                        MinutePickerView(selectedMinutes: $selectedMinutes)
                            .foregroundColor(colorScheme == .dark ? .white : .black) // Set text color based on color scheme
                    }

                    if isRunning {
                        Image(systemName: "clock.fill") // Clock symbol when timer is running
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        Text("Time Remaining:")
                            .font(.title) // Increase font size
                            .foregroundColor(.white)
                            .padding(.top)

                        Text(timeFormatted(timeRemaining))
                            .font(.system(size: 50, weight: .bold)) // Increase font size and make it bold
                            .foregroundColor(.white)
                            .onReceive(timer) { _ in
                                if isRunning {
                                    timeRemaining = max(timeRemaining - 1, 0)
                                    if timeRemaining <= 0 {
                                        isRunning = false
                                        showBlinkingScreen = true
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity) // Expand to fill the available space
                    }

                    if !isRunning {
                        Button(action: startTimer) {
                            Text("Start")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(15)
                                .padding(.horizontal, 30)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                        }
                    } else {
                        Button(action: stopTimer) {
                            Text("Stop")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(15)
                                .padding(.horizontal, 30)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(40)
                        }
                    }
                }
            }

            if showBlinkingScreen {
                BlinkingScreenView(endTimerAction: {
                    showBlinkingScreen = false
                })
            }
        }
    }

    func startTimer() {
        isRunning = true
        timeRemaining = TimeInterval(selectedMinutes * 60)
    }

    func stopTimer() {
        isRunning = false
        showBlinkingScreen = false
    }

    func timeFormatted(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}



struct MinutePickerView: View {
    @Binding var selectedMinutes: Int
    let minuteRange = 1...60

    var body: some View {
        Picker("Select Minutes", selection: $selectedMinutes) {
            ForEach(minuteRange, id: \.self) { minute in
                Text("\(minute) minute\(minute == 1 ? "" : "s")")
                    .tag(minute)
            }
        }
        .pickerStyle(.wheel)
        .labelsHidden()
        .padding()
        .colorScheme(.dark)
    }
}

struct BlinkingScreenView: View {
    var endTimerAction: () -> Void

    @State private var blinkOpacity: Double = 1.0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .opacity(blinkOpacity)

            VStack {
                Spacer()

                Text("Time's up!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding()

                Spacer() // Center the text vertically

                Button(action: endTimerAction) {
                    Text("End Timer")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(15)
                        .padding(.horizontal, 30)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(30)
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0).repeatForever()) {
                blinkOpacity = 0.1
            }
        }
    }
}
