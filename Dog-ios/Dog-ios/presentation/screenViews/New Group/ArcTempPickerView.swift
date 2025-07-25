import SwiftUI

struct ACSpeedPickerView: View {
    @Binding var selectedSpeed: Int // AC Speed as integer

    var body: some View {
        VStack{
            VStack{
                GeometryReader { geometry in
                    ZStack {
                        // Moving bump on blue arc
                        ACSpeedArcWithBumpView(selectedSpeed: selectedSpeed)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 5))
                            .animation(.easeInOut(duration: 0.2), value: selectedSpeed)
                            .padding(.bottom , 5)

                        // Ticks
                        ACSpeedTickMarksView()
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)

                        // Handle (draggable)
                        ACSpeedDragHandleView(selectedSpeed: $selectedSpeed, geometry: geometry)

                        // Center label
                        VStack {
                            Spacer()
                            Text("AC Speed")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                            Text("\(selectedSpeed)")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }

                        // Bottom labels
                        HStack {
                            Text("16")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            Spacer()
                            Text("32")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        .padding(.top, geometry.size.height - 20)
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.horizontal , 10)
                .frame(height: 200)
            }
            .frame(height: 200)
            .clipped()
        }
        .frame(height: 100)
    }
}

struct ACSpeedArcWithBumpView: Shape {
    var selectedSpeed: Int
    let bumpRadius: CGFloat = 16

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let arcRadius = rect.width / 2
        
        // Calculate bump position
        let angleDeg = ACSpeedCalculator.calculateAngle(for: selectedSpeed).degrees
        let angleRad = angleDeg * .pi / -180
        
        // Point on arc where bump is centered
        let arcX = center.x + arcRadius * cos(.pi - angleRad)
        let arcY = center.y + arcRadius * sin(.pi - angleRad)
        let bumpCenter = CGPoint(x: arcX, y: arcY)
        
        // Compute outward direction (normal to arc at point)
        let normalAngle = .pi - angleRad - (.pi / 2)
        
        // Calculate the angular range to exclude for the bump
        let gapAngle = asin((bumpRadius - 2 ) / arcRadius )
        let bumpStartAngle = (.pi - angleRad) - gapAngle
        let bumpEndAngle = (.pi - angleRad) + gapAngle
        
        // Draw left side arc (from 0 to start of bump gap)
        if bumpStartAngle > 0 {
            path.move(to: CGPoint(x: center.x + arcRadius, y: center.y))
            path.addArc(center: center,
                        radius: arcRadius,
                        startAngle: .degrees(1),
                        endAngle: .radians(bumpStartAngle),
                        clockwise: false)
        }
        
        // Draw right side arc (from end of bump gap to 180 degrees)
        if bumpEndAngle > 0 {
            path.move(to: CGPoint(x: center.x + arcRadius, y: center.y))
            path.addArc(center: center,
                        radius: arcRadius,
                        startAngle: .degrees(0),
                        endAngle: .radians(bumpEndAngle),
                        clockwise: true)
        }
        
        // Add the bump
        let start = CGPoint(
            x: bumpCenter.x + bumpRadius * cos(Double(normalAngle)),
            y: bumpCenter.y + bumpRadius * sin(normalAngle)
        )
        
        path.move(to: start)
        path.addArc(center: bumpCenter,
                    radius: bumpRadius,
                    startAngle: .radians(normalAngle),
                    endAngle: .radians(normalAngle + .pi),
                    clockwise: false)

        return path
    }
}

struct ACSpeedTickMarksView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = rect.width / 2 - 12

        // Draw ticks for AC speed range 16 to 32 (17 integer values)
        // Each integer speed gets one tick mark
        for tick in 0...16 {
            let speedValue = 16 + tick // Convert tick to speed (16 to 32)
            let angle = .pi * Double(tick) / 16 // 16 ticks across 180 degrees
            
            // All ticks are same length since we only have integer values
            let tickLength: Double = 15.0

            let inner = CGPoint(
                x: center.x + (radius - tickLength) * cos(angle - .pi),
                y: center.y + (radius - tickLength) * sin(angle - .pi)
            )
            let outer = CGPoint(
                x: center.x + radius * cos(angle - .pi),
                y: center.y + radius * sin(angle - .pi)
            )
            path.move(to: inner)
            path.addLine(to: outer)
        }

        return path
    }
}

struct ACSpeedDragHandleView: View {
    @Binding var selectedSpeed: Int
    let geometry: GeometryProxy

    var body: some View {
        let radius = geometry.size.width / 2 - 12
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height)
        let angle = ACSpeedCalculator.calculateAngle(for: selectedSpeed).radians - .pi

        let point = CGPoint(
            x: center.x + radius * cos(Double(angle)),
            y: center.y + radius * sin(angle)
        )

        return Circle()
            .fill(Color.blue)
            .frame(width: 26, height: 26)
            .position(point)
            .gesture(DragGesture().onChanged { value in
                let dx = value.location.x - center.x
                let dy = value.location.y - center.y
                var angle = atan2(dy, dx)
                angle += .pi // normalize to [0, π]
                let percentage = max(0, min(angle / .pi, 1))
                let speedValue = 16.0 + (percentage * 16.0) // Map to 16-32 range
                
                // Round to nearest integer
                selectedSpeed = Int(round(speedValue))
                
                // Ensure it stays within bounds
                selectedSpeed = max(16, min(selectedSpeed, 32))
            })
    }
}

struct ACSpeedCalculator {
    static func calculateAngle(for speed: Int) -> Angle {
        let percentage = Double(speed - 16) / 16.0 // Normalize 16-32 range to 0-1
        return .degrees(percentage * 180)
    }
}

struct ACSpeedPickerPreview: View {
    @State private var acSpeed: Int = 24 // Default AC speed
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                ACSpeedPickerView(selectedSpeed: $acSpeed)
                
                // Display selected value
                Text("Selected AC Speed: \(acSpeed)")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
            }
        }
    }
}

#Preview {
    ACSpeedPickerPreview()
}
