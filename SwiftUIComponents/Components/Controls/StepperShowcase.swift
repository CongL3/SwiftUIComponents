import SwiftUI

// MARK: - Native iOS Stepper Showcase
// This component demonstrates native SwiftUI Stepper
// NO custom implementations - pure native Apple UI only

public struct NativeStepperShowcase: SwiftUIComponent {
    public let configuration: NativeStepperConfiguration
    @State private var value: Double = 0.0
    
    public init(configuration: NativeStepperConfiguration) {
        self.configuration = configuration
        self._value = State(initialValue: configuration.value)
    }
    
    public init() {
        self.configuration = NativeStepperConfiguration()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: configuration.spacing) {
            // Label
            if !configuration.label.isEmpty {
                Text(configuration.label)
                    .font(configuration.labelFont)
                    .foregroundStyle(configuration.labelColor)
            }
            
            // Native iOS Stepper
            stepperView
            
            // Current Value Display
            if configuration.showCurrentValue {
                Text("Current: \(value, specifier: configuration.valueFormat)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
        }
        .onChange(of: value) { oldValue, newValue in
            configuration.onValueChange?(newValue)
        }
    }
    
    @ViewBuilder
    private var stepperView: some View {
        switch configuration.displayStyle {
        case .withLabel:
            Stepper(
                configuration.label,
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            
        case .withValue:
            Stepper(
                "\(configuration.label): \(value, specifier: configuration.valueFormat)",
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            
        case .labelsHidden:
            Stepper(
                configuration.label,
                value: $value,
                in: configuration.range,
                step: configuration.step
            )
            .labelsHidden()
            
        case .customFormat:
            Stepper(value: $value, in: configuration.range, step: configuration.step) {
                HStack {
                    Text(configuration.label)
                        .font(configuration.labelFont)
                    Spacer()
                    Text("\(value, specifier: configuration.valueFormat)")
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Configuration

public struct NativeStepperConfiguration: ComponentConfiguration {
    public let label: String
    public let value: Double
    public let range: ClosedRange<Double>
    public let step: Double
    public let displayStyle: NativeStepperDisplayStyle
    public let showCurrentValue: Bool
    public let spacing: CGFloat
    public let labelFont: Font
    public let labelColor: Color
    public let valueFormat: String
    public let onValueChange: ((Double) -> Void)?
    
    public init(
        label: String = "Value",
        value: Double = 0.0,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1.0,
        displayStyle: NativeStepperDisplayStyle = .withLabel,
        showCurrentValue: Bool = true,
        spacing: CGFloat = 8,
        labelFont: Font = .headline,
        labelColor: Color = .primary,
        valueFormat: String = "%.0f",
        onValueChange: ((Double) -> Void)? = nil
    ) {
        self.label = label
        self.value = value
        self.range = range
        self.step = step
        self.displayStyle = displayStyle
        self.showCurrentValue = showCurrentValue
        self.spacing = spacing
        self.labelFont = labelFont
        self.labelColor = labelColor
        self.valueFormat = valueFormat
        self.onValueChange = onValueChange
    }
    
    // ComponentConfiguration requirements
    public static var displayName: String { "Native Stepper Showcase" }
    public static var category: ComponentCategory { .controls }
    public static var minimumIOSVersion: String { "16.0" }
    public static var description: String { "Showcase of native iOS Stepper component with different display styles" }
}

// MARK: - Convenience Methods

extension NativeStepperShowcase {
    public static func withLabel(
        label: String,
        value: Double = 0.0,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1.0
    ) -> NativeStepperShowcase {
        NativeStepperShowcase(configuration: NativeStepperConfiguration(
            label: label,
            value: value,
            range: range,
            step: step,
            displayStyle: .withLabel
        ))
    }
    
    public static func withValue(
        label: String,
        value: Double = 0.0,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1.0
    ) -> NativeStepperShowcase {
        NativeStepperShowcase(configuration: NativeStepperConfiguration(
            label: label,
            value: value,
            range: range,
            step: step,
            displayStyle: .withValue
        ))
    }
    
    public static func labelsHidden(
        label: String,
        value: Double = 0.0,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1.0
    ) -> NativeStepperShowcase {
        NativeStepperShowcase(configuration: NativeStepperConfiguration(
            label: label,
            value: value,
            range: range,
            step: step,
            displayStyle: .labelsHidden
        ))
    }
    
    public static func customFormat(
        label: String,
        value: Double = 0.0,
        range: ClosedRange<Double> = 0...100,
        step: Double = 1.0,
        valueFormat: String = "%.1f"
    ) -> NativeStepperShowcase {
        NativeStepperShowcase(configuration: NativeStepperConfiguration(
            label: label,
            value: value,
            range: range,
            step: step,
            displayStyle: .customFormat,
            valueFormat: valueFormat
        ))
    }
}

// MARK: - SwiftUI Preview

#Preview("Native Stepper Showcase") {
    NavigationStack {
        ScrollView {
            VStack(spacing: 24) {
                // Standard Stepper
                VStack(alignment: .leading, spacing: 8) {
                    Text("Standard Style")
                        .font(.headline)
                    NativeStepperShowcase.withLabel(
                        label: "Quantity",
                        value: 5,
                        range: 0...20
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Value Display Stepper
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Value Display")
                        .font(.headline)
                    NativeStepperShowcase.withValue(
                        label: "Temperature",
                        value: 20,
                        range: -10...40,
                        step: 0.5
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Compact Stepper
                VStack(alignment: .leading, spacing: 8) {
                    Text("Labels Hidden")
                        .font(.headline)
                    NativeStepperShowcase.labelsHidden(
                        label: "Volume",
                        value: 50,
                        range: 0...100,
                        step: 5
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Custom Format Stepper
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Format")
                        .font(.headline)
                    NativeStepperShowcase.customFormat(
                        label: "Rating",
                        value: 3.5,
                        range: 0...5,
                        step: 0.5,
                        valueFormat: "%.1f ⭐"
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle("Native Stepper Styles")
    }
} 