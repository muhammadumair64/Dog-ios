import SwiftUI

struct TemperaturePicker: View {
    @State private var temperature: Double = 30.0
    @State private var isDragging = false
    
    private let minTemp: Double = 0
    private let maxTemp: Double = 50
    private let sliderHeight: CGFloat = 400
    private let sliderWidth: CGFloat = 80
    
    // Generate temperature marks (0, 5, 10, 15, ..., 50)
    private var temperatureMarks: [Int] {
        stride(from: Int(maxTemp), through: Int(minTemp), by: -5).map { $0 }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.9),
                    Color.blue.opacity(0.7),
                    Color.teal.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Main container
            HStack(spacing: 10) {
                // Temperature labels on the left
                VStack(spacing: 0) {
                    ForEach(temperatureMarks, id: \.self) { temp in
                        HStack {
                            Spacer()
                            Text("\(temp)°C")
                                .font(temp == Int(temperature) ? .title2.bold() : .body)
                                .foregroundColor(temp == Int(temperature) ? .cyan : .white.opacity(0.7))
                                .scaleEffect(temp == Int(temperature) ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: temperature)
                        }
                        .frame(height: sliderHeight / CGFloat(temperatureMarks.count - 1))
                    }
                }
                .frame(width: 40)
                
                // Slider track with curved line and tick marks
                ZStack {
                    // Background track with major and minor tick marks
                    TickMarksView(
                        minTemp: minTemp,
                        maxTemp: maxTemp,
                        sliderHeight: sliderHeight,
                        sliderWidth: sliderWidth
                    ).padding(.leading, 10)
                    
                    // Curved line
                    CurvedSliderLine(
                        temperature: temperature,
                        minTemp: minTemp,
                        maxTemp: maxTemp,
                        sliderHeight: sliderHeight,
                        sliderWidth: sliderWidth
                    )
                    .padding(.leading, 10)
                    // Draggable thumb
                    SliderThumb(
                        temperature: $temperature,
                        isDragging: $isDragging,
                        minTemp: minTemp,
                        maxTemp: maxTemp,
                        sliderHeight: sliderHeight
                    )
                }
                .frame(width: sliderWidth, height: sliderHeight)
                
                // Current temperature display
                VStack {
                    Text("\(Int(temperature))°C")
                        .font(.largeTitle.bold())
                        .foregroundColor(.cyan)
                    
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(width: 80)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 20)
            )
        }
    }
}

struct TickMarksView: View {
    let minTemp: Double
    let maxTemp: Double
    let sliderHeight: CGFloat
    let sliderWidth: CGFloat
    
    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let totalRange = maxTemp - minTemp
            let pixelsPerDegree = sliderHeight / CGFloat(totalRange)
            
            // Draw all tick marks (every 1 degree)
            for temp in Int(minTemp)...Int(maxTemp) {
                let progress = Double(temp - Int(minTemp)) / totalRange
                let y = sliderHeight - (CGFloat(progress) * sliderHeight)
                
                let isMajorTick = temp % 5 == 0
                let tickWidth: CGFloat = isMajorTick ? 15 : 8
                let tickOpacity: Double = isMajorTick ? 0.4 : 0.25
                let tickThickness: CGFloat = isMajorTick ? 1.5 : 1
                
                // Right side tick mark with space from main line
                var path = Path()
                path.move(to: CGPoint(x: centerX + 3, y: y))
                path.addLine(to: CGPoint(x: centerX + 3 + tickWidth, y: y))
                
                context.stroke(
                    path,
                    with: .color(.white.opacity(tickOpacity)),
                    style: StrokeStyle(lineWidth: tickThickness, lineCap: .round)
                )
            }
            
            // Draw main vertical line
            var mainLine = Path()
            mainLine.move(to: CGPoint(x: centerX, y: 0))
            mainLine.addLine(to: CGPoint(x: centerX, y: sliderHeight))
            
            context.stroke(
                mainLine,
                with: .color(.white.opacity(0.3)),
                style: StrokeStyle(lineWidth: 1)
            )
        }
        .frame(width: sliderWidth, height: sliderHeight)
    }
}

struct CurvedSliderLine: View {
    let temperature: Double
    let minTemp: Double
    let maxTemp: Double
    let sliderHeight: CGFloat
    let sliderWidth: CGFloat
    
    private var thumbPosition: CGFloat {
        let progress = (temperature - minTemp) / (maxTemp - minTemp)
        return sliderHeight - (progress * sliderHeight)
    }
    
    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let curveAmount: CGFloat = 20
            
            var path = Path()
            
            // Start from top
            path.move(to: CGPoint(x: centerX, y: 0))
            
            // Line to before curve
            if thumbPosition > 30 {
                path.addLine(to: CGPoint(x: centerX, y: thumbPosition - 30))
            }
            
            // Create curved section around thumb
            let curveStart = max(0, thumbPosition - 30)
            let curveEnd = min(sliderHeight, thumbPosition + 30)
            let curveMid = thumbPosition
            
            // Add quadratic curve that bulges out
            path.addQuadCurve(
                to: CGPoint(x: centerX, y: curveEnd),
                control: CGPoint(x: centerX + curveAmount, y: curveMid)
            )
            
            // Line to bottom
            if curveEnd < sliderHeight {
                path.addLine(to: CGPoint(x: centerX, y: sliderHeight))
            }
            
            // Draw the path with gradient
            let gradient = Gradient(colors: [
                .cyan.opacity(0.8),
                .blue.opacity(1.0),
                .blue.opacity(0.8)
            ])
            
            context.stroke(
                path,
                with: .linearGradient(
                    gradient,
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: 0, y: sliderHeight)
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
        }
        .frame(width: sliderWidth, height: sliderHeight)
    }
}

struct SliderThumb: View {
    @Binding var temperature: Double
    @Binding var isDragging: Bool
    let minTemp: Double
    let maxTemp: Double
    let sliderHeight: CGFloat
    
    private var thumbPosition: CGFloat {
        let progress = (temperature - minTemp) / (maxTemp - minTemp)
        return sliderHeight - (progress * sliderHeight)
    }
    
    var body: some View {
        ZStack {
            // Outer glow when dragging
            if isDragging {
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .blur(radius: 10)
            }
            
            // Main thumb
            Circle()
                .fill(Color.white)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.cyan, lineWidth: 2)
                )
                .overlay(
                    Circle()
                        .fill(Color.cyan)
                        .frame(width: 16, height: 16)
                        .opacity(0.8)
                )
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isDragging)
        }
        .position(x: 40, y: thumbPosition)
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    let newPosition = value.location.y
                    let progress = 1 - (newPosition / sliderHeight)
                    let clampedProgress = max(0, min(1, progress))
                    temperature = minTemp + (clampedProgress * (maxTemp - minTemp))
                    
                    // Round to nearest 0.5
                    temperature = round(temperature * 2) / 2
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
    }
}

// Preview
struct TemperaturePicker_Previews: PreviewProvider {
    static var previews: some View {
        TemperaturePicker()
    }
}

// Main App
struct TemperaturePickerApp: App {
    var body: some Scene {
        WindowGroup {
            TemperaturePicker()
        }
    }
}
