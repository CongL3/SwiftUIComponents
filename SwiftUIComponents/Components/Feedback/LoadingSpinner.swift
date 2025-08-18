import SwiftUI

// MARK: - Loading Spinner Component

public struct LoadingSpinner: SwiftUIComponent {
    public let configuration: LoadingSpinnerConfiguration
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0
    @State private var scaleEffect: Double = 1.0
    @State private var pulseOpacity: Double = 1.0
    
    public init(configuration: LoadingSpinnerConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = LoadingSpinnerConfiguration()
    }
    
    public var body: some View {
        VStack(spacing: configuration.labelSpacing) {
            // Spinner
            spinnerView
                .frame(width: configuration.size, height: configuration.size)
                .onAppear {
                    startAnimations()
                }
                .onDisappear {
                    stopAnimations()
                }
            
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    @ViewBuilder
    private var spinnerView: some View {
        switch configuration.style {
        case .circular:
            circularSpinner
        case .dots:
            dotsSpinner
        case .bars:
            barsSpinner
        case .pulse:
            pulseSpinner
        case .bounce:
            bounceSpinner
        }
    }
    
    private var circularSpinner: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                configuration.color,
                style: StrokeStyle(
                    lineWidth: configuration.lineWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotationAngle))
            .animation(
                .linear(duration: configuration.animationDuration)
                .repeatForever(autoreverses: false),
                value: rotationAngle
            )
    }
    
    private var dotsSpinner: some View {
        HStack(spacing: configuration.size * 0.1) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(configuration.color)
                    .frame(width: configuration.size * 0.2, height: configuration.size * 0.2)
                    .scaleEffect(scaleEffect)
                    .animation(
                        .easeInOut(duration: configuration.animationDuration)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: scaleEffect
                    )
            }
        }
    }
    
    private var barsSpinner: some View {
        HStack(spacing: configuration.size * 0.1) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: configuration.size * 0.02)
                    .fill(configuration.color)
                    .frame(
                        width: configuration.size * 0.12,
                        height: configuration.size * (0.3 + 0.4 * scaleEffect)
                    )
                    .animation(
                        .easeInOut(duration: configuration.animationDuration)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.15),
                        value: scaleEffect
                    )
            }
        }
    }
    
    private var pulseSpinner: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(configuration.color, lineWidth: configuration.lineWidth)
                    .scaleEffect(1 + Double(index) * 0.3 * scaleEffect)
                    .opacity(pulseOpacity / Double(index + 1))
                    .animation(
                        .easeInOut(duration: configuration.animationDuration * 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                        value: scaleEffect
                    )
            }
        }
    }
    
    private var bounceSpinner: some View {
        HStack(spacing: configuration.size * 0.05) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(configuration.color)
                    .frame(width: configuration.size * 0.25, height: configuration.size * 0.25)
                    .offset(y: -configuration.size * 0.2 * scaleEffect)
                    .animation(
                        .easeInOut(duration: configuration.animationDuration * 0.8)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: scaleEffect
                    )
            }
        }
    }
    
    private func startAnimations() {
        isAnimating = true
        
        switch configuration.style {
        case .circular:
            withAnimation {
                rotationAngle = 360
            }
        case .dots, .bars, .bounce:
            withAnimation {
                scaleEffect = 0.3
            }
        case .pulse:
            withAnimation {
                scaleEffect = 1.0
                pulseOpacity = 0.3
            }
        }
    }
    
    private func stopAnimations() {
        isAnimating = false
        rotationAngle = 0
        scaleEffect = 1.0
        pulseOpacity = 1.0
    }
}

// MARK: - Configuration

public struct LoadingSpinnerConfiguration: ComponentConfiguration {
    public static let displayName = "Loading Spinner"
    public static let category = ComponentCategory.feedback
    public static let minimumIOSVersion = "16.0"
    public static let description = "Activity indicators with custom animations"
    
    // Content
    public let label: String
    
    // Style
    public let style: LoadingSpinnerStyle
    public let size: CGFloat
    public let lineWidth: CGFloat
    
    // Colors
    public let color: Color
    public let labelColor: Color
    
    // Typography
    public let labelFont: Font
    
    // Layout
    public let labelSpacing: CGFloat
    
    // Animation
    public let animationDuration: Double
    
    public init(
        label: String = "",
        style: LoadingSpinnerStyle = .circular,
        size: CGFloat = 40,
        lineWidth: CGFloat = 4,
        color: Color = .blue,
        labelColor: Color = .secondary,
        labelFont: Font = .caption,
        labelSpacing: CGFloat = 12,
        animationDuration: Double = 1.0
    ) {
        self.label = label
        self.style = style
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.labelColor = labelColor
        self.labelFont = labelFont
        self.labelSpacing = labelSpacing
        self.animationDuration = animationDuration
    }
}

public enum LoadingSpinnerStyle: CaseIterable {
    case circular
    case dots
    case bars
    case pulse
    case bounce
}

// MARK: - Convenience Initializers

extension LoadingSpinner {
    public static func circular(
        label: String = "",
        size: CGFloat = 40,
        color: Color = .blue
    ) -> LoadingSpinner {
        LoadingSpinner(configuration: LoadingSpinnerConfiguration(
            label: label,
            style: .circular,
            size: size,
            color: color
        ))
    }
    
    public static func dots(
        label: String = "",
        size: CGFloat = 40,
        color: Color = .blue
    ) -> LoadingSpinner {
        LoadingSpinner(configuration: LoadingSpinnerConfiguration(
            label: label,
            style: .dots,
            size: size,
            color: color
        ))
    }
    
    public static func bars(
        label: String = "",
        size: CGFloat = 40,
        color: Color = .blue
    ) -> LoadingSpinner {
        LoadingSpinner(configuration: LoadingSpinnerConfiguration(
            label: label,
            style: .bars,
            size: size,
            color: color
        ))
    }
    
    public static func pulse(
        label: String = "",
        size: CGFloat = 60,
        color: Color = .blue
    ) -> LoadingSpinner {
        LoadingSpinner(configuration: LoadingSpinnerConfiguration(
            label: label,
            style: .pulse,
            size: size,
            color: color
        ))
    }
    
    public static func bounce(
        label: String = "",
        size: CGFloat = 40,
        color: Color = .blue
    ) -> LoadingSpinner {
        LoadingSpinner(configuration: LoadingSpinnerConfiguration(
            label: label,
            style: .bounce,
            size: size,
            color: color
        ))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 40) {
        // Circular Spinner
        LoadingSpinner.circular(
            label: "Loading...",
            color: .blue
        )
        
        // Dots Spinner
        LoadingSpinner.dots(
            label: "Please wait",
            color: .green
        )
        
        // Bars Spinner
        LoadingSpinner.bars(
            label: "Processing",
            color: .orange
        )
        
        // Pulse Spinner
        LoadingSpinner.pulse(
            label: "Syncing",
            color: .purple
        )
        
        // Bounce Spinner
        LoadingSpinner.bounce(
            label: "Uploading",
            color: .red
        )
        
        Spacer()
    }
    .padding()
} 