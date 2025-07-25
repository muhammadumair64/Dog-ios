import SwiftUI
import Foundation

struct CircularTemperatureSeekBar: View {
    @State private var currentTemp: Double = 16 // Start at beginning of arc

    private let minTemp: Double = 16
    private let maxTemp: Double = 32
    private let tempRange: Double = 16

    // ✅ Updated angles
    private let startAngle: Double = -225
    private let endAngle: Double = 45
    private let totalSweep: Double = 270

    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let ringWidth: CGFloat = 14
            let radius = size / 2
            let arcRadius = radius - ringWidth / 2
            let progress = (currentTemp - minTemp) / tempRange
            let angle = startAngle + progress * totalSweep

            ZStack {
                // Base Arc (dashed)
                Arc(startAngle: .degrees(startAngle), endAngle: .degrees(endAngle))
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: size - ringWidth, height: size - ringWidth)

                // Filled Arc
                Arc(startAngle: .degrees(startAngle), endAngle: .degrees(angle))
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: ringWidth, lineCap: .round))
                    .frame(width: size - ringWidth, height: size - ringWidth)

                // Tick labels
                // Tick labels and dashes
                ForEach([16.0, 20.0, 24.0, 28.0, 32.0], id: \.self) { tick in
                    let tickAngle = angleForTemp(tick)
                    
                    // Draw dashed line tick
                    let inner = pointOnCircle(angle: tickAngle, radius: arcRadius - 8, center: radius)
                    let outer = pointOnCircle(angle: tickAngle, radius: arcRadius + 8, center: radius)
                    Path { path in
                        path.move(to: inner)
                        path.addLine(to: outer)
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                    .foregroundColor(.white)

                    // Draw label slightly further out
                    let labelPos = pointOnCircle(angle: tickAngle, radius: arcRadius + 24, center: radius)
                    Text("\(Int(tick))°C")
                        .font(Font.custom(FontHelper.regular.rawValue, size: 12))
                        .foregroundColor(.white.opacity(0.8))
                        .position(labelPos)
                }


                // Thumb aligned with arc
                let thumbPos = pointOnCircle(angle: angle, radius: arcRadius, center: radius)
                Circle()
                    .fill(Color.white)
                    .frame(width: 26, height: 26)
                    .shadow(radius: 4)
                    .position(thumbPos)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let vector = CGVector(dx: value.location.x - radius, dy: value.location.y - radius)
                                var dragAngle = atan2(vector.dy, vector.dx).toDegrees
                                if dragAngle < 0 { dragAngle += 360 } // normalize to 0–360

                                let normalizedStart = (startAngle < 0 ? startAngle + 360 : startAngle)
                                let normalizedEnd = (endAngle < 0 ? endAngle + 360 : endAngle)

                                // Check if dragAngle is between 135° (start) and 360° OR 0° to 45° (end)
                                let inArcRange: Bool
                                let clampedAngle: Double

                                if normalizedStart > normalizedEnd {
                                    // Arc wraps past 0 (e.g., 135° to 45°)
                                    inArcRange = dragAngle >= normalizedStart || dragAngle <= normalizedEnd
                                    clampedAngle = {
                                        if dragAngle >= normalizedStart {
                                            return dragAngle
                                        } else if dragAngle <= normalizedEnd {
                                            return dragAngle + 360
                                        } else {
                                            return dragAngle
                                        }
                                    }()
                                } else {
                                    // Normal arc
                                    inArcRange = dragAngle >= normalizedStart && dragAngle <= normalizedEnd
                                    clampedAngle = min(max(dragAngle, normalizedStart), normalizedEnd)
                                }

                                guard inArcRange else { return }

                                let percent = (clampedAngle - normalizedStart) / totalSweep
                                let temp = minTemp + tempRange * percent
                                currentTemp = round(temp)

                               // DDLogDebug("Drag Angle: \(dragAngle), Clamped: \(clampedAngle), Temp: \(currentTemp)")
                            }
                    )


                // Center temperature label
                Text("\(Int(currentTemp))°C")
                    .font(Font.custom(FontHelper.regular.rawValue, size: 38))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
        }
        .padding(40)
    }

    private func angleForTemp(_ temp: Double) -> Double {
        let percent = (temp - minTemp) / tempRange
        return startAngle + totalSweep * percent
    }

    private func pointOnCircle(angle: Double, radius: CGFloat, center: CGFloat) -> CGPoint {
        let radian = Angle(degrees: angle).radians
        return CGPoint(
            x: Foundation.cos(radian) * radius + center,
            y: Foundation.sin(radian) * radius + center
        )
    }
}

// Arc shape for specific angle range
struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false)
        return path
    }
}

extension Double {
    var toDegrees: Double { self * 180 / .pi }
    var toRadians: Double { self * .pi / 180 }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CircularTemperatureSeekBar()
            .frame(width: 300, height: 300)
    }
}
