import SwiftUI

struct CanvasShowcase: View {
    @State private var animationPhase: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            NativeCanvasExample(
                title: "Basic Canvas Drawing",
                description: "Native SwiftUI Canvas with basic shapes",
                style: .basic,
                animationPhase: animationPhase
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeCanvasExample(
                title: "Animated Canvas",
                description: "Canvas with animated elements",
                style: .animated,
                animationPhase: animationPhase
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeCanvasExample(
                title: "Canvas with Gradients",
                description: "Canvas using gradient fills and effects",
                style: .gradients,
                animationPhase: animationPhase
            )
            
            Divider()
                .padding(.horizontal)
            
            NativeCanvasExample(
                title: "Complex Canvas Drawing",
                description: "Advanced Canvas with multiple drawing techniques",
                style: .complex,
                animationPhase: animationPhase
            )
            
            Divider()
                .padding(.horizontal)
            
            // Animation controls section
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Animation Controls")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text("Control Canvas animations and effects")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Animation Phase:")
                        Spacer()
                        Text("\(animationPhase, specifier: "%.2f")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Slider(value: $animationPhase, in: 0...1)
                        .tint(.blue)
                }
                
                Text("Canvas is available on iOS 15.0+")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                animationPhase = 1.0
            }
        }
    }
}

public enum NativeCanvasStyle: CaseIterable {
    case basic
    case animated
    case gradients
    case complex
    
    var displayName: String {
        switch self {
        case .basic: return "Basic"
        case .animated: return "Animated"
        case .gradients: return "Gradients"
        case .complex: return "Complex"
        }
    }
}

struct NativeCanvasExample: View {
    let title: String
    let description: String
    let style: NativeCanvasStyle
    let animationPhase: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Group {
                switch style {
                case .basic:
                    Canvas { context, size in
                        // Draw basic shapes
                        let rect = CGRect(x: 10, y: 10, width: 60, height: 40)
                        context.fill(Path(rect), with: .color(.blue))
                        
                        let circle = Path(ellipseIn: CGRect(x: 80, y: 10, width: 40, height: 40))
                        context.fill(circle, with: .color(.green))
                        
                        let triangle = Path { path in
                            path.move(to: CGPoint(x: 140, y: 50))
                            path.addLine(to: CGPoint(x: 160, y: 10))
                            path.addLine(to: CGPoint(x: 180, y: 50))
                            path.closeSubpath()
                        }
                        context.fill(triangle, with: .color(.orange))
                    }
                    
                case .animated:
                    Canvas { context, size in
                        let centerX = size.width / 2
                        let centerY = size.height / 2
                        let radius = 20.0 + (animationPhase * 15.0)
                        
                        // Animated circle
                        let circle = Path(ellipseIn: CGRect(
                            x: centerX - radius,
                            y: centerY - radius,
                            width: radius * 2,
                            height: radius * 2
                        ))
                        
                        context.fill(circle, with: .color(.blue.opacity(0.7)))
                        
                        // Rotating elements
                        let angle = animationPhase * 360
                        for i in 0..<6 {
                            let transform = CGAffineTransform(translationX: centerX, y: centerY)
                                .rotated(by: .pi * (angle + Double(i * 60)) / 180.0)
                                .translatedBy(x: 25, y: -5)
                            
                            let smallCircle = Path(ellipseIn: CGRect(x: -5, y: -5, width: 10, height: 10))
                            context.fill(smallCircle.applying(transform), with: .color(.red))
                        }
                    }
                    
                case .gradients:
                    Canvas { context, size in
                        let gradient = Gradient(colors: [.purple, .pink, .orange])
                        
                        // Gradient rectangle
                        let rect = CGRect(x: 10, y: 10, width: 80, height: 40)
                        context.fill(
                            Path(rect),
                            with: .linearGradient(
                                gradient,
                                startPoint: CGPoint(x: 10, y: 10),
                                endPoint: CGPoint(x: 90, y: 50)
                            )
                        )
                        
                        // Radial gradient circle
                        let circle = Path(ellipseIn: CGRect(x: 100, y: 10, width: 40, height: 40))
                        context.fill(
                            circle,
                            with: .radialGradient(
                                gradient,
                                center: CGPoint(x: 120, y: 30),
                                startRadius: 0,
                                endRadius: 20
                            )
                        )
                    }
                    
                case .complex:
                    Canvas { context, size in
                        let centerX = size.width / 2
                        let centerY = size.height / 2
                        
                        // Background
                        context.fill(
                            Path(CGRect(origin: .zero, size: size)),
                            with: .color(.black.opacity(0.1))
                        )
                        
                        // Draw wave
                        let waveHeight = 10.0 * animationPhase
                        let wavePath = Path { path in
                            path.move(to: CGPoint(x: 0, y: centerY))
                            for x in stride(from: 0, through: size.width, by: 2) {
                                let y = centerY + sin((x / 20.0) + (animationPhase * 10)) * waveHeight
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        
                        context.stroke(wavePath, with: .color(.blue), lineWidth: 2)
                        
                        // Draw particles
                        for i in 0..<8 {
                            let x = (Double(i) / 7.0) * size.width
                            let y = centerY + sin((x / 20.0) + (animationPhase * 10)) * waveHeight
                            
                            let particle = Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
                            context.fill(particle, with: .color(.red.opacity(0.8)))
                        }
                    }
                }
            }
            .frame(height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text("Style: .\(style.displayName.lowercased())")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        CanvasShowcase()
            .padding()
    }
} 