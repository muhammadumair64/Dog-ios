import SwiftUI

struct ArcTimerView: View {
    @State private var hours: Double = 2.5
    let maxHours: Double = 12.0
    let minHours: Double = 0.0

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                ZStack {
                    // MARK: - Dashed Arc (180° to 0° → Left to Right, Upper Half)
                    ArcShape()
                        .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [6, 8]))
                        .foregroundColor(Color.orange)
                        .frame(width: 260, height: 130)

                    // MARK: - Arrow Thumb on Top of Arc
                    GeometryReader { geometry in
                        let radius = geometry.size.width / 2.0
                        let angle = angleForHour(hours)

                        Image(systemName: "arrowtriangle.up.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(180 - angle ))// Adjust rotation for upper arc
                            .position(positionOnArc(
                                center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height),
                                radius: radius,
                                angle: angle))
                    }
                    .frame(width: 260, height: 130)

                    // MARK: - Center Time Label
                    VStack(spacing: 4) {
                        Text(String(format: "%.1f", hours))
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        Text("Hours")
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .offset(y: 50) // Move label down since arc is now on top

                    HStack{
                        // MARK: - Minus Button
                        Button(action: {
                            if hours > minHours {
                                hours -= 0.5
                            }
                          
                            print("MY Angle = \(angleForHour(hours))")
                        })
                        {
                            Circle()
                                .fill(Color.gray.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("–")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        Spacer()

                        // MARK: - Plus Button
                        Button(action: {
                            if hours < maxHours {
                                hours += 0.5
                            }
                            print("MY Angle = \(angleForHour(hours))")
                        })
                        {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("+")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                )
                        }
                        
                    }
                    .padding(.top,100)
                    .padding(.horizontal , 60)


                    // MARK: - Start/End Labels
                    HStack {
                        Text("0")
                            .foregroundColor(.white.opacity(0.7))
                            .offset(x: -130, y: -15) // Left side for 0 hours
                        Spacer()
                        Text("12")
                            .foregroundColor(.white.opacity(0.7))
                            .offset(x: 130, y: -15) // Right side for 12 hours
                    }
                    .frame(width: 260)
                }
                .padding(.bottom, 30)

                // MARK: - Bottom Arrow Button
                Button(action: {
                    print("Arrow button pressed with \(hours) hours.")
                }) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: "arrow.right")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                        )
                }

                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Map 0h = 180°, 12h = 0° (for upper arc, left to right)
    func angleForHour(_ hour: Double) -> Double {
        return 180 - (hour / maxHours) * 180
    }

    // MARK: - Calculate Arrow Position
    func positionOnArc(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        let radians = Angle(degrees: angle).radians
        let x = center.x + radius * cos(radians)
        let y = center.y - radius * sin(radians) // Negative for upper arc
        return CGPoint(x: x, y: y)
    }
}

// MARK: - Arc Shape: Upper Half (0° to 180°, Right to Left)
struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), // Center at bottom
                    radius: rect.width / 2,
                    startAngle: .degrees(180),    // Right
                    endAngle: .degrees(0),    // Left
                    clockwise: false)           // Counter-clockwise for upper arc
        return path
    }
}
