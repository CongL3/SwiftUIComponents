import SwiftUI

// MARK: - Native Apple Slider Showcase
// This component demonstrates native SwiftUI Slider
// NO custom implementations - pure native Apple UI only

public struct NativeSliderShowcase: SwiftUIComponent {
    public let configuration: NativeSliderConfiguration
    @State private var value: Double = 0.0
    
    public init(configuration: NativeSliderConfiguration) {
        self.configuration = configuration
        self._value = State(initialValue: configuration.value)
    }
    
    public init() {
        self.configuration = NativeSliderConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label with current value
            HStack {
                Text(configuration.label)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text(configuration.valueFormatter(value))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // Native SwiftUI Slider
            nativeSlider
            
            // Range labels
            if configuration.showRangeLabels {
                HStack {
                    Text(configuration.valueFormatter(configuration.range.lowerBound))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(configuration.valueFormatter(configuration.range.upperBound))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Helper text
            if !configuration.helperText.isEmpty {
                Text(configuration.helperText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onChange(of: value) { oldValue, newValue in
            configuration.onValueChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var nativeSlider: some View {
        switch configuration.style {
        case .default:
            Slider(
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            
        case .withLabels:
            Slider(
                value: $value,
                in: configuration.range,
                step: configuration.step
            ) {
                Text(configuration.label)
            } minimumValueLabel: {
                Image(systemName: configuration.minimumValueIcon)
                    .foregroundStyle(.secondary)
            } maximumValueLabel: {
                Image(systemName: configuration.maximumValueIcon)
                    .foregroundStyle(.secondary)
            }
            
        case .tinted:
            Slider(
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            .tint(configuration.tintColor)
            
        case .stepped:
            Slider(
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            .tint(configuration.tintColor)
        }
    }
}

// MARK: - Configuration

public struct NativeSliderConfiguration: ComponentConfiguration {
    public static let displayName = "Native Slider Showcase"
    public static let category: ComponentCategory = .controls
    public static let minimumIOSVersion = "16.0"
    public static let description = "Showcase of native Apple slider"
    
    // Content
    public let label: String
    public let value: Double
    public let range: ClosedRange<Double>
    public let step: Double
    public let helperText: String
    
    // Native Style Selection
    public let style: NativeSliderStyle
    public let tintColor: Color
    public let minimumValueIcon: String
    public let maximumValueIcon: String
    public let showRangeLabels: Bool
    
    // Layout
    public let spacing: CGFloat
    
    // Formatting
    public let valueFormatter: (Double) -> String
    
    // Behavior
    public let onValueChange: ((Double) -> Void)?
    
    public init(
        label: String = "Slider",
        value: Double = 50.0,
        range: ClosedRange<Double> = 0.0...100.0,
        step: Double = 1.0,
        helperText: String = "",
        style: NativeSliderStyle = .default,
        tintColor: Color = .blue,
        minimumValueIcon: String = "minus",
        maximumValueIcon: String = "plus",
        showRangeLabels: Bool = true,
        spacing: CGFloat = 8,
        valueFormatter: @escaping (Double) -> String = { String(format: "%.0f", $0) },
        onValueChange: ((Double) -> Void)? = nil
    ) {
        self.label = label
        self.value = value
        self.range = range
        self.step = step
        self.helperText = helperText
        self.style = style
        self.tintColor = tintColor
        self.minimumValueIcon = minimumValueIcon
        self.maximumValueIcon = maximumValueIcon
        self.showRangeLabels = showRangeLabels
        self.spacing = spacing
        self.valueFormatter = valueFormatter
        self.onValueChange = onValueChange
    }
}

// MARK: - Native Slider Styles

public enum NativeSliderStyle: CaseIterable {
    case `default`      // Standard native slider
    case withLabels     // Slider with min/max labels
    case tinted         // Slider with custom tint
    case stepped        // Slider with visible steps
    
    public var displayName: String {
        switch self {
        case .default: return "Default"
        case .withLabels: return "With Labels"
        case .tinted: return "Tinted"
        case .stepped: return "Stepped"
        }
    }
    
    public var description: String {
        switch self {
        case .default: return "Standard native slider"
        case .withLabels: return "Slider with min/max value labels"
        case .tinted: return "Slider with custom tint color"
        case .stepped: return "Slider with defined step values"
        }
    }
}

// MARK: - Convenience Initializers

extension NativeSliderShowcase {
    public static func `default`(
        label: String,
        value: Double = 50.0,
        range: ClosedRange<Double> = 0.0...100.0
    ) -> NativeSliderShowcase {
        NativeSliderShowcase(configuration: NativeSliderConfiguration(
            label: label,
            value: value,
            range: range,
            helperText: "Standard native slider",
            style: .default
        ))
    }
    
    public static func withLabels(
        label: String,
        value: Double = 50.0,
        range: ClosedRange<Double> = 0.0...100.0,
        minimumIcon: String = "minus",
        maximumIcon: String = "plus"
    ) -> NativeSliderShowcase {
        NativeSliderShowcase(configuration: NativeSliderConfiguration(
            label: label,
            value: value,
            range: range,
            helperText: "Slider with min/max labels",
            style: .withLabels,
            minimumValueIcon: minimumIcon,
            maximumValueIcon: maximumIcon
        ))
    }
    
    public static func tinted(
        label: String,
        value: Double = 50.0,
        range: ClosedRange<Double> = 0.0...100.0,
        tintColor: Color = .blue
    ) -> NativeSliderShowcase {
        NativeSliderShowcase(configuration: NativeSliderConfiguration(
            label: label,
            value: value,
            range: range,
            helperText: "Slider with custom tint color",
            style: .tinted,
            tintColor: tintColor
        ))
    }
    
    public static func stepped(
        label: String,
        value: Double = 50.0,
        range: ClosedRange<Double> = 0.0...100.0,
        step: Double = 10.0
    ) -> NativeSliderShowcase {
        NativeSliderShowcase(configuration: NativeSliderConfiguration(
            label: label,
            value: value,
            range: range,
            step: step,
            helperText: "Slider with defined steps",
            style: .stepped,
            tintColor: .orange
        ))
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        ScrollView {
            LazyVStack(spacing: 30) {
                // All Native Slider Styles
                Group {
                    Text("Native Apple Slider")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Default Style
                    NativeSliderShowcase.default(
                        label: "Volume",
                        value: 75.0,
                        range: 0.0...100.0
                    )
                    
                    Divider()
                    
                    // With Labels Style
                    NativeSliderShowcase.withLabels(
                        label: "Brightness",
                        value: 60.0,
                        range: 0.0...100.0,
                        minimumIcon: "sun.min",
                        maximumIcon: "sun.max"
                    )
                    
                    Divider()
                    
                    // Tinted Style
                    NativeSliderShowcase.tinted(
                        label: "Temperature",
                        value: 22.5,
                        range: 16.0...30.0,
                        tintColor: .red
                    )
                    
                    Divider()
                    
                    // Stepped Style
                    NativeSliderShowcase.stepped(
                        label: "Quality",
                        value: 80.0,
                        range: 0.0...100.0,
                        step: 20.0
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Native Slider")
        .navigationBarTitleDisplayMode(.large)
    }
} 