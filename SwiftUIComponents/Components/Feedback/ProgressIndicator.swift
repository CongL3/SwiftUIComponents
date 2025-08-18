import SwiftUI

// MARK: - Progress Indicator Component

public struct ProgressIndicator: SwiftUIComponent {
    public let configuration: ProgressIndicatorConfiguration
    @State private var animationProgress: Double = 0
    
    public init(configuration: ProgressIndicatorConfiguration) {
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = ProgressIndicatorConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.labelSpacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Progress View
            progressView
            
            // Progress Text
            if configuration.showProgressText {
                HStack {
                    if configuration.showPercentage {
                        Text("\(Int(configuration.progress * 100))%")
                            .font(configuration.progressFont)
                            .foregroundStyle(configuration.progressTextColor)
                    }
                    
                    Spacer()
                    
                    if !configuration.statusText.isEmpty {
                        Text(configuration.statusText)
                            .font(configuration.progressFont)
                            .foregroundStyle(configuration.progressTextColor)
                    }
                }
            }
        }
        .onAppear {
            if configuration.isIndeterminate {
                startIndeterminateAnimation()
            }
        }
    }
    
    @ViewBuilder
    private var progressView: some View {
        switch configuration.style {
        case .linear:
            linearProgressView
        case .circular:
            circularProgressView
        case .ring:
            ringProgressView
        case .dots:
            dotsProgressView
        }
    }
    
    @ViewBuilder
    private var linearProgressView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: configuration.cornerRadius)
                    .fill(configuration.backgroundColor)
                    .frame(height: configuration.thickness)
                
                // Progress
                if configuration.isIndeterminate {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .fill(configuration.progressColor)
                        .frame(
                            width: geometry.size.width * 0.3,
                            height: configuration.thickness
                        )
                        .offset(x: geometry.size.width * animationProgress - geometry.size.width * 0.3)
                } else {
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .fill(configuration.progressColor)
                        .frame(
                            width: geometry.size.width * configuration.progress,
                            height: configuration.thickness
                        )
                        .animation(.easeInOut(duration: configuration.animationDuration), value: configuration.progress)
                }
            }
        }
        .frame(height: configuration.thickness)
    }
    
    @ViewBuilder
    private var circularProgressView: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(configuration.backgroundColor, lineWidth: configuration.thickness)
            
            // Progress Circle
            if configuration.isIndeterminate {
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        configuration.progressColor,
                        style: StrokeStyle(
                            lineWidth: configuration.thickness,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(animationProgress * 360))
            } else {
                Circle()
                    .trim(from: 0, to: configuration.progress)
                    .stroke(
                        configuration.progressColor,
                        style: StrokeStyle(
                            lineWidth: configuration.thickness,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: configuration.animationDuration), value: configuration.progress)
            }
        }
        .frame(width: configuration.size, height: configuration.size)
    }
    
    @ViewBuilder
    private var ringProgressView: some View {
        ZStack {
            // Background Ring
            Circle()
                .stroke(configuration.backgroundColor, lineWidth: configuration.thickness)
            
            // Progress Ring with Gradient
            Circle()
                .trim(from: 0, to: configuration.progress)
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [
                            configuration.progressColor.opacity(0.3),
                            configuration.progressColor
                        ]),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270 * configuration.progress - 90)
                    ),
                    style: StrokeStyle(
                        lineWidth: configuration.thickness,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: configuration.animationDuration), value: configuration.progress)
            
            // Center Text
            if configuration.showCenterText {
                Text("\(Int(configuration.progress * 100))%")
                    .font(.system(size: configuration.size * 0.2, weight: .semibold))
                    .foregroundStyle(configuration.progressColor)
            }
        }
        .frame(width: configuration.size, height: configuration.size)
    }
    
    @ViewBuilder
    private var dotsProgressView: some View {
        HStack(spacing: configuration.dotSpacing) {
            ForEach(0..<configuration.dotCount, id: \.self) { index in
                Circle()
                    .fill(dotColor(for: index))
                    .frame(width: configuration.dotSize, height: configuration.dotSize)
                    .scaleEffect(dotScale(for: index))
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: animationProgress
                    )
            }
        }
        .onAppear {
            if configuration.isIndeterminate {
                animationProgress = 1
            }
        }
    }
    
    private func dotColor(for index: Int) -> Color {
        if configuration.isIndeterminate {
            return configuration.progressColor
        } else {
            let progressIndex = Int(configuration.progress * Double(configuration.dotCount))
            return index < progressIndex ? configuration.progressColor : configuration.backgroundColor
        }
    }
    
    private func dotScale(for index: Int) -> Double {
        if configuration.isIndeterminate {
            return 1.0
        } else {
            let progressIndex = Int(configuration.progress * Double(configuration.dotCount))
            return index < progressIndex ? 1.2 : 1.0
        }
    }
    
    private func startIndeterminateAnimation() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            animationProgress = 1
        }
    }
}

// MARK: - Configuration

public struct ProgressIndicatorConfiguration: ComponentConfiguration {
    public static let displayName = "Progress Indicator"
    public static let category = ComponentCategory.feedback
    public static let minimumIOSVersion = "16.0"
    public static let description = "Progress indicators with multiple styles and animations"
    
    public let label: String
    public let progress: Double
    public let style: ProgressIndicatorStyle
    public let progressColor: Color
    public let backgroundColor: Color
    public let labelColor: Color
    public let progressTextColor: Color
    public let labelFont: Font
    public let progressFont: Font
    public let thickness: CGFloat
    public let size: CGFloat
    public let cornerRadius: CGFloat
    public let labelSpacing: CGFloat
    public let showProgressText: Bool
    public let showPercentage: Bool
    public let showCenterText: Bool
    public let statusText: String
    public let isIndeterminate: Bool
    public let animationDuration: Double
    public let dotCount: Int
    public let dotSize: CGFloat
    public let dotSpacing: CGFloat
    
    public init(
        label: String = "",
        progress: Double = 0.0,
        style: ProgressIndicatorStyle = .linear,
        progressColor: Color = .blue,
        backgroundColor: Color = Color(.systemGray5),
        labelColor: Color = .primary,
        progressTextColor: Color = .secondary,
        labelFont: Font = .subheadline,
        progressFont: Font = .caption,
        thickness: CGFloat = 8,
        size: CGFloat = 60,
        cornerRadius: CGFloat = 4,
        labelSpacing: CGFloat = 8,
        showProgressText: Bool = false,
        showPercentage: Bool = true,
        showCenterText: Bool = false,
        statusText: String = "",
        isIndeterminate: Bool = false,
        animationDuration: Double = 0.3,
        dotCount: Int = 5,
        dotSize: CGFloat = 8,
        dotSpacing: CGFloat = 6
    ) {
        self.label = label
        self.progress = max(0, min(1, progress))
        self.style = style
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.labelColor = labelColor
        self.progressTextColor = progressTextColor
        self.labelFont = labelFont
        self.progressFont = progressFont
        self.thickness = thickness
        self.size = size
        self.cornerRadius = cornerRadius
        self.labelSpacing = labelSpacing
        self.showProgressText = showProgressText
        self.showPercentage = showPercentage
        self.showCenterText = showCenterText
        self.statusText = statusText
        self.isIndeterminate = isIndeterminate
        self.animationDuration = animationDuration
        self.dotCount = dotCount
        self.dotSize = dotSize
        self.dotSpacing = dotSpacing
    }
}

public enum ProgressIndicatorStyle: CaseIterable {
    case linear
    case circular
    case ring
    case dots
}

// MARK: - Convenience Initializers

extension ProgressIndicator {
    public static func linear(progress: Double, label: String = "") -> ProgressIndicator {
        ProgressIndicator(configuration: ProgressIndicatorConfiguration(
            label: label,
            progress: progress,
            style: .linear,
            showProgressText: !label.isEmpty
        ))
    }
    
    public static func circular(progress: Double, size: CGFloat = 60) -> ProgressIndicator {
        ProgressIndicator(configuration: ProgressIndicatorConfiguration(
            progress: progress,
            style: .circular,
            size: size
        ))
    }
    
    public static func ring(progress: Double, size: CGFloat = 80) -> ProgressIndicator {
        ProgressIndicator(configuration: ProgressIndicatorConfiguration(
            progress: progress,
            style: .ring,
            size: size,
            showCenterText: true
        ))
    }
    
    public static func dots(isIndeterminate: Bool = true) -> ProgressIndicator {
        ProgressIndicator(configuration: ProgressIndicatorConfiguration(
            style: .dots,
            isIndeterminate: isIndeterminate
        ))
    }
    
    public static func indeterminate(style: ProgressIndicatorStyle = .linear) -> ProgressIndicator {
        ProgressIndicator(configuration: ProgressIndicatorConfiguration(
            style: style,
            isIndeterminate: true
        ))
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 30) {
        // Linear Progress
        ProgressIndicator.linear(progress: 0.7, label: "Download Progress")
        
        HStack(spacing: 30) {
            // Circular Progress
            ProgressIndicator.circular(progress: 0.6)
            
            // Ring Progress
            ProgressIndicator.ring(progress: 0.8)
        }
        
        // Dots Progress
        ProgressIndicator.dots()
        
        // Indeterminate Linear
        ProgressIndicator.indeterminate()
        
        Spacer()
    }
    .padding()
} 